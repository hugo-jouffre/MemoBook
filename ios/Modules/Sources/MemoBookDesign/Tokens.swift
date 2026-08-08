import SwiftUI
import UIKit

/// Design tokens MemoBook.
///
/// Source : `memobook-design.md` (Drive), **corrigé** selon les
/// recommandations de `critique_design_memobook.md` :
///
/// 1. une seule couleur d'action — le vert de marque ;
/// 2. l'orange strictement réservé à l'état « enregistrement en cours » ;
/// 3. une grille unique : marge horizontale 20 pt, verticale sur une échelle de 8 pt.
///
/// ⚠️ Provisoire : ces valeurs seront remplacées par l'export des maquettes
/// Figma une fois celles-ci figées. Ne pas coder de couleur en dur ailleurs.
public enum MemoBookColor {
    /// Identité et **unique** couleur d'action : boutons primaires, liens, sélection.
    public static let brand = Color(hex: 0x23_51_36)

    /// Enregistrement en cours, et rien d'autre. Jamais un lien, jamais un CTA.
    /// C'est le rouge du micro qui s'allume : lui donner un autre rôle lui
    /// retirerait son sens.
    public static let recording = Color(hex: 0xD9_78_36)

    /// Texte principal — un noir chaud, jamais du noir pur.
    public static let ink = Color(hex: 0x2D_24_1E)
    public static let inkSecondary = Color(hex: 0x2D_24_1E).opacity(0.6)

    /// Fond de l'app : le gris système groupé, comme les apps natives.
    public static let background = Color(uiColor: .systemGroupedBackground)
    public static let surface = Color(uiColor: .secondarySystemGroupedBackground)
    public static let separator = Color(uiColor: .separator)

    /// Surfaces « carnet » : aperçu du livre, cartes de couverture.
    /// Le fond papier ne doit jamais servir de fond d'écran système.
    public static let paper = Color(hex: 0xE8_DC_CF)
    public static let paperSoft = Color(hex: 0xF5_EF_EB)

    public static let valid = Color(hex: 0x24_C1_4B)
    public static let warning = Color(hex: 0xF5_C5_18)
    public static let error = Color(hex: 0xFF_6B_3E)
}

/// Échelle d'espacement de 8 pt, plus la marge latérale de référence.
public enum MemoBookSpacing {
    public static let xs: CGFloat = 8
    public static let s: CGFloat = 16
    public static let m: CGFloat = 24
    public static let l: CGFloat = 32
    public static let xl: CGFloat = 40

    /// Marge horizontale unique de tous les écrans (iOS HIG).
    public static let screenMargin: CGFloat = 20

    /// Rayon unique des champs et des cartes.
    public static let cornerRadius: CGFloat = 14

    /// Taille minimale d'une cible tactile.
    public static let minimumTapTarget: CGFloat = 44
}

public enum MemoBookFont {
    /// Serif — réservé aux titres de **carnet**, jamais aux titres d'écran
    /// système. C'est la distinction que demande la critique design.
    public static func bookTitle(_ size: CGFloat = 28) -> Font {
        .system(size: size, weight: .semibold, design: .serif)
    }

    /// Chrome de l'app : police système, comme n'importe quelle app native.
    public static let screenTitle = Font.system(.largeTitle, weight: .bold)
    public static let sectionTitle = Font.system(.headline)
    public static let body = Font.system(.body)
    public static let caption = Font.system(.footnote)

    /// Transcription brute : le monospace signale « pas encore mis en forme ».
    public static let transcript = Font.system(.callout, design: .monospaced)
}

extension Color {
    /// Initialise depuis un entier hexadécimal (`0x23_51_36`).
    init(hex: UInt32) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: 1
        )
    }
}
