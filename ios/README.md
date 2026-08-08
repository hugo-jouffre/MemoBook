# Application iOS MemoBook

SwiftUI, iOS 17+, Swift 6 en concurrence stricte.

## Démarrer

```bash
brew install xcodegen     # une seule fois
make project              # génère MemoBook.xcodeproj depuis project.yml
open MemoBook.xcodeproj
```

Le `.xcodeproj` **n'est pas versionné** : `project.yml` en est la source. Ça évite les
conflits Git sur le pbxproj et rend la structure du projet lisible en revue de code.

L'app parle par défaut à `http://localhost:3000` — lance `cd ../backend && npm run dev` avant.

```bash
make test                 # tests des modules, sur simulateur
make build                # compile l'app
```

## Structure

```
App/                      Point d'entrée : @main, Info.plist, assets. Volontairement mince.
Modules/                  Le vrai code, en paquet SwiftPM local « MemoBookKit »
├── MemoBookCore          Modèles et décodage. Aucune dépendance.
├── MemoBookDesign        Design tokens et composants partagés.
├── MemoBookNetworking    Client d'API, stockage du token, multipart.
├── MemoBookRecording     Capture audio (AVFoundation) et permissions.
└── MemoBookFeature       Écrans SwiftUI et modèles de vue.
Tests/                    Tests de la cible app (l'essentiel est dans Modules/Tests).
```

Les modèles de vue dépendent du protocole `MemoBookAPI`, pas du client HTTP : `PreviewAPI`
(dans `MemoBookFeature`) en fournit une implémentation en mémoire, ce qui permet de
travailler les écrans et de les tester sans back-end lancé.

## Les trois écrans

1. **`MemoListView`** — les carnets, bouton `+` en position fixe en haut à droite.
2. **`MemoDetailView`** — l'écran central : le bouton d'enregistrement, la waveform, les
   souvenirs avec leur statut de transcription, et la carte de génération du carnet.
3. **`BookPreviewView`** — le PDF, dans QuickLook.

## Design tokens

`MemoBookDesign/Tokens.swift` reprend `memobook-design.md`, **corrigé** selon
`critique_design_memobook.md` :

- une seule couleur d'action, le vert de marque `#235136` ;
- l'orange `#D97836` strictement réservé à l'état « enregistrement en cours » — jamais un
  lien, jamais un CTA ;
- marge horizontale unique de 20 pt, espacements verticaux sur une échelle de 8 pt ;
- serif uniquement pour les titres de **carnet**, jamais pour le chrome système ;
- SF Symbols en trait fin, pas de rendu 3D.

> ⚠️ Ces valeurs sont provisoires. Elles seront remplacées par l'export Figma une fois les
> maquettes figées. Ne code aucune couleur en dur ailleurs que dans ce fichier.

## Ce qui n'est pas encore là

Pas d'authentification utilisateur (l'app s'enregistre comme un appareil anonyme), pas de
wizard d'onboarding, pas d'écran de chat, pas de paiement. Ces écrans dépendent d'arbitrages
Figma encore ouverts — notamment l'unification des deux versions de l'accueil.
