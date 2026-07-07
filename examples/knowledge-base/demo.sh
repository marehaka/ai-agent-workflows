#!/bin/bash
# Demo: build the knowledge base from schema.sql, ingest three sample
# entries, and run the queries an agent would run before starting work.
# Usage: bash demo.sh   (requires sqlite3 >= 3.34 for the trigram tokenizer)

set -e
DB=$(mktemp /tmp/kb-demo.XXXXXX.db)
SCHEMA="$(dirname "$0")/schema.sql"

sqlite3 "$DB" < "$SCHEMA" > /dev/null

sqlite3 "$DB" <<'SQL'
-- Three sample entries (fictional, format-faithful)
INSERT INTO entries VALUES
 ('AP-001','AP','2026-03-14','demo',
  'Worker edited a file shared with another branch without flagging it',
  'Semantic merge conflict surfaced only after both PRs merged. Close-records now require a shared-file warning.',
  'active','SR 12-2 Block 3',NULL,'2026-03'),
 ('DEC-001','DEC','2026-04-02','demo',
  'DB migrations never ship on a worker''s sole authority',
  'All migrations stop at a human-approved gate regardless of test status.',
  'accepted','SR 15-1',NULL,'2026-04'),
 ('BP-001','BP','2026-05-20','demo',
  'Judge the first token of a command before pattern-matching the rest',
  'Prevents heredoc/quoted-string false positives that train people to ignore the guard.',
  'active','SR 21-3',NULL,'2026-05');

INSERT INTO bp_ap_detail (entry_id, severity, recurrence) VALUES
 ('AP-001','critical',2),
 ('BP-001','medium',1);

INSERT INTO entries_fts (entry_id, text)
  SELECT entry_id, title || ' ' || COALESCE(body,'') FROM entries;
SQL

echo "== Agent query 1: anything known about 'merge conflict'? =="
sqlite3 -header -column "$DB" "
  SELECT e.entry_id, e.kind, e.title
  FROM entries_fts f JOIN entries e ON e.entry_id = f.entry_id
  WHERE entries_fts MATCH 'merge conflict';"

echo
echo "== Agent query 2: all critical anti-patterns =="
sqlite3 -header -column "$DB" "
  SELECT e.entry_id, e.title, d.severity, d.recurrence
  FROM entries e JOIN bp_ap_detail d USING(entry_id)
  WHERE e.kind='AP' AND d.severity='critical';"

echo
echo "== Agent query 3: settled decisions (do not re-open) =="
sqlite3 -header -column "$DB" "
  SELECT entry_id, title FROM entries WHERE kind='DEC' AND status='accepted';"

rm -f "$DB"
echo
echo "(demo db removed — the real one is rebuilt from markdown by an ingest script)"
