//
//  QuestionMarkViewController.swift
//  business-finance-app-ios
//
//  Created by Mohammed Aslam on 2023/1/24.
//  Copyright © 2023 Viable Labs. All rights reserved.
//

import UIKit

class QuestionMarkViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        let destribeTextView: UITextView = UITextView()
        destribeTextView.font = UIFont.appFont(ofSize: 16, weight: .regular)
        destribeTextView.textColor = UIColor(hexString: "#2B395C")
        destribeTextView.text = "Wie unsere Standard-Gutscheine  und die Sachbezugs-Gutscheine allgemein funktionieren:\n \n Als Sachbezug bekommst Du von Deiner Chefin \n \n Deinem Chef jeden Monat Guthaben zur Verfügung gestellt, welches Du im Laufe des Monats in einen Gutschein oder mehrere Gutscheine wandeln kannst bzw. wegen gesetzlicher Vorschriften sogar wandeln musst (= das Ansparen von Guthaben ist nicht möglich).\n \n Daher gibt es bei Riso folgende Vorgehensweise:\n \n A. Monatliche Auswahl \n  \n Bis zum 15. des Monats .. \n \n  kannst Du Dir Gutscheine aus der Liste der Anbieter auswählen und 'kaufen'. Bezahlt werden sie automatisch mit Deinem Guthaben.\n \n  Tipp: Lasse kein Guthaben verfallen und reize immer das maximale Budget aus. \n Du kannst nicht mehr Gutschein kaufen, als Du Guthaben hast (= es ist also keine Zuzahlung möglich). \n \n  Ab dem 16. des Monats ...\n\n  prozessieren wir alle Eure Gutscheinbestellungen und kümmern uns um die korrekte steuerliche Abwicklung und Dokumentation. Don't worry, it's our hazzle.\n\n  Um den 25. eines jeden Monats ... \n \n  erhältst Du Deine individuellen Einlöse-Codes in der Riso-App zur Verfügung gestellt. Auf der Detailseite des Gutscheins siehst Du alle Details inklusive der Einlösebedingungen (on-/offline, mit oder ohne Sicherheitscode, etc.). Diese sind abhängig vom Anbieter und wir haben keinen Einfluss auf sie.\n\n  Nutze nun die Codes. Um den Überblick zu behalten, kannst Du sie als eingelöst markieren, sobald du einkaufen warst.\n\n  Was passiert, wenn Du Deine Auswahl vergisst, bzw. nicht rechtzeitig per App kommunizierst?\n\n   B. Standardgutschein\n\n   Keine Panik, dafür gibt es den Standardgutschein.\n\n   Einmal hinterlegt, besorgen wir Dir automatisch Deinen Standardgutschein / Deine Standardgutscheine, falls Du bis zum 15. des Monats Dein Guthaben nicht ausgegeben hast. Du kannst Standardgutscheine auch jederzeit löschen und neu festlegen.Und richtig:  Wenn Du immer denselben Gutschein möchtest, kannst Du diesen als Standardgutschein hinterlegen und auf die monatliche Wahl verzichten.\n \n   Lastly:Warum gibt es keinen Amazon-Gutschein? \n\n  Lasst uns versuchen, kompliziertes Steuerrecht möglichst einfach zu erklären: \n Amazon ist (schon lange) kein (reiner) Händler mehr, sondern ein Marktplatz mit Millionen von Händlern weltweit. Die neuen Gesetze zum Sachbezug verbieten  jedoch Gutscheine von Marktplätzen. Deswegen sind auch Zalando und weitere ähnliche Marktplätze nicht in der Gutscheinauswahl verfügbar."
        destribeTextView.font = .systemFont(ofSize: 16)
        self.view.addSubview(destribeTextView)
        destribeTextView.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(20 * AutoSizeScaleX)
            make.right.equalTo(self.view).offset(-20 * AutoSizeScaleX)
            make.top.equalTo(self.view).offset(24 * AutoSizeScaleX)
            make.bottom.equalTo(self.view).offset(-20 * AutoSizeScaleX)
        }
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
