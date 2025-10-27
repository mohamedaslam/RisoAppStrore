//
//  Disclaimer+Factory.swift
//  business-finance-app-ios
//
//  Created by Razvan Rusu on 25/06/2018.
//  Copyright © 2018 Viable Labs. All rights reserved.
//

import Foundation

struct DisclaimerDetails {
    let title: String
    let details: [String]
}

class DisclaimerFactory {
    func getDetails(for product: Product) -> DisclaimerDetails {
        switch product.name {
        case let x where x.lowercased().contains("good") || x.lowercased().contains("sachen"):
            return DisclaimerDetails(
                title: product.name,
                details: [
                    "Du bestätigst, nur Deine eigenen Belege zu fotografieren.",
                    "Du bestätigst, dass Dir die auf dem Beleg aufgeführten Kosten tatsächlich angefallen sind.",
                    "Es kann maximal die Belegsumme erstattet werden.",
                    "Sachbezug darf maximal für 44 Euro pro Monat gewährt werden.",
                    "Du bist mit den Datenschutzbestimmungen einverstanden."
                ]
            )
        case let x where x.lowercased().contains("lunch") || x.lowercased().contains("mittagessen"):
            return DisclaimerDetails(
                title: product.name,
                details: [
                    "Du bestätigst, nur Deine eigenen Belege zu fotografieren.",
                    "Du bestätigst, dass Dir die auf dem Beleg aufgeführten Kosten tatsächlich angefallen sind.",
                    "Es kann maximal die Belegsumme erstattet werden.",
                    "Du bestätigst, die aufgeführten Lebensmittel / Mahlzeiten während Deiner Arbeitszeit konsumiert zu haben.",
                    "Restaurantbesuche können in der Zeit von 11-16 Uhr als Mittagessen akzeptiert werden. Außerhalb dieser Zeit ist eine Anrechnung nicht möglich.",
                    "Einkäufe (z.B. in Lebensmittelgeschäften) zählen ab 16.00 Uhr zur Verpflegung für den folgenden Arbeitstag.",
                    "Der Zuschuss beträgt pro Arbeitstag maximal 6,33 Euro (Stand 2018) für bis zu 15 Arbeitstage pro Monat (=94,95 Euro).",
                    "Eine Übertragung nicht genutzter Beträge in den Folgemonat ist nicht möglich.",
                    "Du bist mit den Datenschutzbestimmungen einverstanden."
                ]
            )
        case let x where x.lowercased().contains("internet"):
            return DisclaimerDetails(
                title: product.name,
                details: [
                    "Du bestätigst, nur Deine eigenen Belege zu fotografieren.",
                    "Du bestätigst, dass Dir die auf dem Beleg aufgeführten Kosten tatsächlich angefallen sind.",
                    "Es kann maximal die Belegsumme erstattet werden.",
                    "Die Rechnung muss auf Deinen Namen ausgestellt sein.",
                    "Es können bis zu 50 € erstattet werden, maximal der Betrag Deiner Rechnung(en).",
                    "Eine Übertragung nicht genutzter Beträge in den Folgemonat ist nicht möglich.",
                    "Bei Kombi-Paketen, Hardware-Leasing oder Zusatzoptionen werden unsere Steuerexperten unter Umständen einzelnen Positionen entsprechend der aktuellen Gesetzgebung streichen oder kürzen.",
                    "Du bist mit den Datenschutzbestimmungen einverstanden."
                ]
            )
        default:
            return DisclaimerDetails(
                title: product.name,
                details: [
                    "Du bestätigst, nur Deine eigenen Belege zu fotografieren.",
                    "Du bestätigst, dass Dir die auf dem Beleg aufgeführten Kosten tatsächlich angefallen sind.",
                    "Es kann maximal die Belegsumme erstattet werden.",
                    "Du bist mit den Datenschutzbestimmungen einverstanden."
                ]
            )
        }
        
    }
}
