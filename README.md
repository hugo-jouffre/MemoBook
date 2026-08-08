# MemoBook

MemoBook est un générateur de carnets audio-visuels : on raconte son périple à voix haute, l’IA transcrit, structure et
illustre le récit, puis APITemplate.io assemble automatiquement le PDF prêt à imprimer.

Le dépôt est un monorepo :

| Dossier | Rôle |
| --- | --- |
| `templates/travel-journal/` | Le template PDF et les schémas qui décrivent le format du carnet. **Source de vérité** : le back-end les lit, il ne les duplique pas. |
| `backend/` | L'API et le pipeline `transcrire → structurer → imprimer`. Node/TypeScript, Fastify, Postgres. [Documentation](backend/README.md). |
| `ios/` | L'application iOS native (SwiftUI). [Documentation](ios/README.md). |

Démarrage rapide : `cd backend && docker compose up -d && npm ci && npx prisma migrate dev && npm run dev`, puis
`cd ios && make project`.

## Vue d’ensemble du workflow

1. **Conversation vocale** – Les voyageurs discutent avec l’agent MemoBook (GPT). Ils peuvent envoyer du texte, des
   photos ou des messages vocaux.
2. **Interprétation par GPT** – L’agent applique le schéma `templates/travel-journal/gpt_image_schema.yaml` pour générer
   un JSON propre :
   - les textes sont classés par jour, avec plusieurs types de mises en page possibles ;
   - les médias reçus sont téléchargés vers Webflow via son API (voir ci-dessous) et l’agent remplace les liens temporaires
     par les URL CDN renvoyées par Webflow ;
   - les stickers, faits amusants et statistiques globaux sont enrichis automatiquement.
3. **Prévisualisation JSON** – Le JSON généré est d’abord envoyé tel quel à APITemplate.io en tant que données de test. Le
   but est uniquement de vérifier le rendu du template sans publier définitivement le carnet.
4. **Publication PDF** – Une fois validé, le même JSON est transmis à l’API `create-pdf` d’APITemplate.io. L’API charge le
   template HTML/CSS (`index.html` + `style.css`), remplace les variables Jinja/Handlebars par les valeurs reçues
   puis renvoie le PDF prêt à être envoyé en impression ou partagé aux voyageurs.

> 💡 **Pourquoi un schéma dédié ?** Le schéma JSON sert de “script” détaillé pour l’agent GPT : il lui indique comment
> nommer les champs, quels blocs activer (layouts, stickers, 4e de couverture…) et quelles validations appliquer. Plus le
> schéma est précis, plus le rendu initial dans APITemplate.io sera fidèle sans retouches manuelles.

## Organisation des fichiers

| Fichier | Rôle |
| --- | --- |
| `templates/travel-journal/index.html` | Structure HTML compatible APITemplate.io. Elle inclut les 6 layouts jour par jour (storyboard inclus), un layout d’annonce de journée, les groupes de stickers et la 4ᵉ de couverture. |
| `templates/travel-journal/style.css` | Styles A5 MemoBook : couverture, sections jour, collage, layout « opener », layout storyboard, stickers groupés et 4ᵉ de couverture. |
| `templates/travel-journal/data.json` | Exemple de payload complet. Il sert à tester rapidement un rendu dans APITemplate.io. |
| `templates/travel-journal/apitemplate-openapi.yaml` | Documentation OpenAPI des appels `create-pdf`. Utile pour brancher l’automatisation NoCode/Backend. |
| `templates/travel-journal/gpt_image_schema.yaml` | Schéma destiné à l’agent GPT. Il décrit comment classer les jours, où uploader les images sur Webflow et comment préparer le JSON final pour APITemplate.io. |
| `templates/travel-journal/sticker_generation_schema.yaml` | Prompt + schéma pour demander à GPT de sélectionner les meilleures images et générer un prompt de sticker compatible `gpt-image-1`. |

## Stockage des images envoyées dans le chat

Oui, nous pouvons **envoyer les photos des utilisateurs vers une API** avant de les réutiliser dans le template. Nous
recommandons Webflow (déjà utilisé pour memo-book.com) :

1. L’agent récupère l’URL temporaire fournie par GPT pour chaque image envoyée par le voyageur.
2. Pour chaque fichier, l’agent effectue un `POST https://api.webflow.com/assets/upload` (ou l’équivalent REST 2.0 si vous
   utilisez une collection CMS) avec :
   ```bash
   curl -X POST "https://api.webflow.com/assets/upload" \
     -H "Authorization: Bearer ${WEBFLOW_API_TOKEN}" \
     -H "accept: application/json" \
     -H "content-type: application/json" \
     -d '{
           "siteId": "<SITE_ID>",
           "fileName": "voyage-j1-aube.jpg",
           "url": "https://files.openai.com/.../source.jpg"
         }'
   ```
3. Webflow renvoie un `assetId` et surtout `url`/`cdnUrl`. Ces URL publiques sont injectées dans `image_uploads[].webflow_cdn`
   puis référencées dans les champs `days[n].photos`, `days[n].opener_photos`, `back_cover.image`, etc.
4. Le token Webflow vit côté serveur, dans la variable d’environnement `WEBFLOW_API_TOKEN` (voir `backend/.env.example`).
   Il ne doit apparaître ni dans ce dépôt, ni dans le JSON envoyé à APITemplate.io.

Grâce à ce flux, toutes les photos partagées dans la conversation GPT sont automatiquement stockées et optimisées sur le CDN
Webflow, prêtes à être réutilisées dans le PDF.

## Templates et layouts disponibles

- **Couverture + statistiques globales**.
- **Layout 1** – Photo pleine largeur en haut puis récit.
- **Layout 2** – Texte à gauche, mosaïque à droite.
- **Layout 3** – Récit + encart « Fun facts ».
- **Layout 4** – Collage créatif façon scrapbook.
- **Layout 5** – « Story opener » pleine page : annonce de journée, grand bloc texte et deux visuels superposés.
- **Layout 6** – Storyboard inspiré du mockup fourni : bandeau jour/date/météo, note inclinée et pile de 3 photos rotatives.
- **Carte d’annonce de journée** – Encadré météo/date/lieu pour introduire chaque jour.
- **Groupes de stickers** – Tampons, emojis, timbres positionnés librement.
- **4ᵉ de couverture** – Page finale avec message personnalisé, photo plein cadre et logo MemoBook.

Ouvrez `templates/travel-journal/data.json` pour voir comment activer chaque combinaison. Copiez ensuite
`index.html` et `style.css` dans un template APITemplate.io (moteur Handlebars/Jinja) et collez le JSON dans l’onglet
« Test Data » pour prévisualiser.

Bon voyage ✈️
