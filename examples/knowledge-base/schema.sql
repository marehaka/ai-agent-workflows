-- Knowledge Base — executable schema (sanitized from the live system)
--
-- Design: markdown logs are the source of truth; this database is a DERIVED
-- INDEX, rebuilt from them by an ingest script. If it breaks, regenerate it.
-- Agents query it (full-text + tags) before starting work.
--
-- Entry kinds: BP (best practice) / AP (anti-pattern) / DEC (decision) /
-- LRN (learning) / QID (open question) — each with a typed, stable ID.

PRAGMA journal_mode = WAL;

DROP TABLE IF EXISTS entry_relations;
DROP TABLE IF EXISTS entry_tags;
DROP TABLE IF EXISTS tags;
DROP TABLE IF EXISTS bp_ap_detail;
DROP TABLE IF EXISTS entries_fts;
DROP TABLE IF EXISTS entries;

-- entries: common spine for all kinds; join target for tags/FTS/relations
CREATE TABLE entries (
  entry_id   TEXT PRIMARY KEY,                 -- e.g. 'BP-077', 'DEC-539'
  kind       TEXT NOT NULL CHECK (kind IN ('BP','AP','DEC','LRN','QID')),
  date       TEXT NOT NULL,                    -- 'YYYY-MM-DD' (free text; ranges allowed)
  agent      TEXT NOT NULL,                    -- which agent/project logged it
  title      TEXT NOT NULL,
  body       TEXT,                             -- description / rationale / answer
  status     TEXT,
  source     TEXT,                             -- drill-down hint to the session record
  commit_sha TEXT,
  month      TEXT NOT NULL                     -- 'YYYY-MM' (derived from source file path)
);
CREATE INDEX idx_entries_kind  ON entries(kind);
CREATE INDEX idx_entries_agent ON entries(agent);
CREATE INDEX idx_entries_date  ON entries(date);

-- bp_ap_detail: rich columns only BP/AP entries need (1:1 with entries)
CREATE TABLE bp_ap_detail (
  entry_id        TEXT PRIMARY KEY REFERENCES entries(entry_id) ON DELETE CASCADE,
  severity        TEXT,        -- critical / medium / minor / process-learning
  context         TEXT,
  example         TEXT,
  description     TEXT,
  alternative     TEXT,
  purpose         TEXT,
  scene           TEXT,
  recurrence      INTEGER,     -- how often this pattern recurred
  last_occurrence TEXT
);

-- tags + entry_tags: controlled vocabulary, M:N normalized
CREATE TABLE tags (
  tag_id    INTEGER PRIMARY KEY,
  namespace TEXT,                              -- severity/agent/domain/scope/type; NULL = free tag
  value     TEXT NOT NULL,
  UNIQUE(namespace, value)
);
CREATE TABLE entry_tags (
  entry_id TEXT    NOT NULL REFERENCES entries(entry_id) ON DELETE CASCADE,
  tag_id   INTEGER NOT NULL REFERENCES tags(tag_id) ON DELETE CASCADE,
  PRIMARY KEY (entry_id, tag_id)
);
CREATE INDEX idx_entry_tags_tag ON entry_tags(tag_id);

-- entry_relations: cross-kind graph (duplicates, promotions, supersessions)
CREATE TABLE entry_relations (
  from_id TEXT NOT NULL REFERENCES entries(entry_id) ON DELETE CASCADE,
  to_id   TEXT NOT NULL REFERENCES entries(entry_id) ON DELETE CASCADE,
  rel     TEXT NOT NULL CHECK (rel IN
            ('relates','duplicate-of','promoted-to','answered-by','supersedes')),
  note    TEXT,
  PRIMARY KEY (from_id, to_id, rel)
);

-- entries_fts: full-text search across all kinds.
-- trigram tokenizer: substring search that also works for CJK languages.
CREATE VIRTUAL TABLE entries_fts USING fts5(
  entry_id UNINDEXED,
  text,
  tokenize = 'trigram'
);
