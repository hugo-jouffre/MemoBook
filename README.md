# MemoBook

MemoBook lets you capture and preserve your travel memories and life’s key moments, simply by recording your voice. Powered by artificial intelligence, your spoken stories are transcribed, enriched, and transformed into a personalized travel journal or life book, ready to be shared or printed.

## Templates

The `templates/travel-journal` directory contains the APITemplate.io assets used to generate PDF travel journals:

- `memobook.html` – HTML template rendered with Jinja-style placeholders expected by APITemplate.io.
- `memobook.css` – Stylesheet snippet loaded by APITemplate.io to apply the MemoBook visual identity.
- `sample_payload.json` – Example payload that can be sent to APITemplate.io to produce the “Claire & Gus en Colombie” booklet.

Each template is designed for an A5 PDF output and supports multiple day layouts (hero photo, split gallery, story with fun facts, collage) along with optional global statistics and decorative stickers.
