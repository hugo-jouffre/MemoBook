# MemoBook Travel Journal Template

This directory contains the assets needed to render the MemoBook travel journal via [APITemplate.io](https://apitemplate.io/):

- `memobook.html` – the HTML template with Jinja-style placeholders that APITemplate.io replaces with values from your payload.
- `memobook.css` – the CSS snippet applied during rendering to give the booklet its MemoBook look & feel.
- `sample_payload.json` – an example payload you can send to the APITemplate.io REST API to generate the “Claire & Gus en Colombie” travel journal.

## Import instructions

1. Create a **PDF** template in APITemplate.io.
2. Paste the contents of `memobook.html` into the template editor and set the engine to *Handlebars / Jinja* compatibility.
3. Add the stylesheet from `memobook.css` to the template's **Custom CSS** section.
4. Optionally paste the JSON in `sample_payload.json` into the **Test Data** tab to preview the rendering.
5. Publish the template and use the payload structure as a reference for your MemoBook automation.

All assets target an A5 page size with zero internal margins, matching the MemoBook printed booklet layout.
