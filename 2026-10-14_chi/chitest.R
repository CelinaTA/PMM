# Chi-Quadrat-Test (KM7-02) – Betriebsdaten
# Angabe: GRG-PMM/5ahwit/2026-09-30-chi-quadrat-test/hausaufgabe.md
# Sollmaß 10,00 mm, Toleranz ± 0,15 mm
#
# Ausführen in VS Code: Zeile markieren und Strg + Enter drücken,
# oder das ganze Skript mit Strg + Shift + S.

library(tidyverse)

# Die Datei liegt im selben Ordner wie dieses Skript. Je nachdem, von wo
# R gestartet wurde, ist der Pfad ein anderer – darum probieren wir mehrere.
datei <- c("betriebsdaten.csv",
           "2026-10-14_chi/betriebsdaten.csv",
           "PMM/2026-10-14_chi/betriebsdaten.csv",
           "../PMM/2026-10-14_chi/betriebsdaten.csv")
datei <- datei[file.exists(datei)][1]
if (is.na(datei)) stop("betriebsdaten.csv nicht gefunden – getwd() zeigt, wo R gerade ist.")


# ---- 0. Der Datensatz ------------------------------------------------------

# iok = "in Ordnung / kein Ausschuss":
# mehr als 0,15 mm vom Sollmaß weg -> "ausserhalb" (Ausschuss)
daten <- read_csv(datei, show_col_types = FALSE) |>
  mutate(iok = if_else(is.na(masse_mm), NA,
                       if_else(abs(masse_mm - 10) > 0.15,
                               "ausserhalb", "in_Toleranz")))

tab <- table(daten$maschine, daten$iok)
addmargins(tab)   # Tabelle mit Summen
#        ausserhalb in_Toleranz Sum
#   M1            0          37  37
#   M2            0          39  39
#   M3            6          34  40
#   Sum           6         110 116


# ---- 1. Vorhersagen (von Hand) ----------------------------------------------

# a) 116 gültige Messungen, nicht 120: Vier Messwerte fehlen (NA).
#    table() lässt NA automatisch weg.
#
# b) Erwartet = Zeilensumme * Spaltensumme / Gesamtsumme
#    M1 außerhalb: 37 * 6 / 116 = 1,91  (NICHT 0 – 0 ist der beobachtete Wert!)
#
# c) Drei der sechs erwarteten Werte liegen unter 5 (die ganze Spalte
#    "ausserhalb": 1,91 / 2,02 / 2,07). Das sind 50 %, die Regel verlangt
#    mindestens 80 % >= 5 -> Regel verletzt -> exakter Test: fisher.test()


# ---- 2. Teststatistik von Hand ----------------------------------------------

erwartet <- outer(rowSums(tab), colSums(tab)) / sum(tab)
round(erwartet, 2)

beitraege <- (tab - erwartet)^2 / erwartet
round(beitraege, 4)

# a) Beitrag = (beobachtet - erwartet)^2 / erwartet
#    | Zelle         | beob. | erwartet | Beitrag                      |
#    | M1 außerhalb  |   0   |   1,91   | (0 - 1,91)^2 / 1,91 = 1,91   |
#    | M2 außerhalb  |   0   |   2,02   | (0 - 2,02)^2 / 2,02 = 2,02   |
#    | M3 außerhalb  |   6   |   2,07   | (6 - 2,07)^2 / 2,07 = 7,47   |

sum(beitraege)                 # 12,02
chisq.test(tab)$statistic      # 12,02 – stimmt mit der Handrechnung überein

# b) Abweichungen zur Handrechnung kommen nur vom Runden der erwarteten Werte.
#
# c) Den größten Beitrag liefert M3 außerhalb (7,47). Das liegt an der größten
#    relativen Abweichung: beobachtet 6 statt erwartet 2,07, also fast dreimal
#    so viel. Am kleinen Nenner liegt es nicht, denn die drei Nenner sind fast
#    gleich groß (~2).


# ---- 3. Unabhängigkeitstest -------------------------------------------------
# H0: Der Ausschuss hängt NICHT von der Maschine ab.

chisq.test(tab)    # X² = 12,022, df = 2, p = 0,0025
fisher.test(tab)   # p = 0,0032

# - Chi und Fisher weichen leicht ab: chisq.test() rechnet mit einer
#   Näherung (Chi-Quadrat-Verteilung), fisher.test() rechnet exakt.
#
# a) df = (Zeilen - 1) * (Spalten - 1) = (3 - 1) * (2 - 1) = 2
#
# b) Warnung: "Chi-squared approximation may be incorrect"
#    (deutsch: "Chi-Quadrat-Approximation kann inkorrekt sein")
#
# c) Wenn die Maschinen tatsächlich gleich viel Ausschuss produzierten, wäre
#    eine Tabelle wie diese (oder eine noch extremere) nur in etwa 0,25 % der
#    Fälle zu erwarten. 0,0025 < 0,05 -> H0 verwerfen.
#    Inhaltlich: Die Maschinen produzieren unterschiedlich viel Ausschuss,
#    und der Unterschied kommt im Wesentlichen von M3.


# ---- 4. Anpassungstest (Sollquote 10 % Ausschuss) ---------------------------
# H0: Die Maschine hat 10 % Ausschuss.

quoten <- daten |>
  filter(!is.na(masse_mm)) |>
  group_by(maschine) |>
  summarise(n = n(), aus = sum(iok == "ausserhalb"), .groups = "drop") |>
  mutate(in_toleranz = n - aus)
quoten

lapply(split(quoten, quoten$maschine), function(q) {
  suppressWarnings(
    chisq.test(c(q$in_toleranz, q$aus), p = c(0.9, 0.1)))
})

# a)
#    | Maschine | beobachtet | erwartet  |  X²  | p-Wert |
#    | M1       |  37 / 0    | 33,3 / 3,7 | 4,11 | 0,043  |
#    | M2       |  39 / 0    | 35,1 / 3,9 | 4,33 | 0,037  |
#    | M3       |  34 / 6    | 36 / 4,0   | 1,11 | 0,292  |
#
# b) M1 und M2 fallen auf (p < 0,05), M3 nicht.
#    Die Richtung zeigt der p-Wert NICHT. Man sieht sie erst beim Vergleich
#    beobachtet vs. erwartet: M1 und M2 haben 0 statt ~4 Ausschussteile,
#    sie sind also BESSER als die Vorgabe.
#
# c) Der Anpassungstest prüft nur, ob die Ausschussquote von 10 % abweicht,
#    egal in welche Richtung. Er schlägt also auch bei "zu gut" an.
#    Über die Qualität des Prozesses (Ursachen, Streuung, Prozessfähigkeit)
#    sagt er nichts aus, und bei kleinem n bedeutet "nicht signifikant"
#    noch lange nicht "alles in Ordnung".
#
# d) Beantwortet:       Passt die Ausschussquote der Maschine zu 10 %?
#    Beantwortet nicht: Ist die Maschine gut oder schlecht? Warum hat M3 mehr
#                       Ausschuss? Welche Maschine ist die beste?


# ---- 5. Voraussetzungen prüfen ----------------------------------------------

# a) Unter 5: M1 außerhalb (1,91), M2 außerhalb (2,02), M3 außerhalb (2,07)
#    -> 3 von 6 Zellen = 50 %
#
# b) 80-%-Regel: NICHT erfüllt (nur 50 % >= 5).
#    p = 0,0025 ist deshalb nur eine unsichere Näherung. Weiterrechnen ist
#    erlaubt, man muss aber zusätzlich den exakten Test machen:
#    fisher.test() liefert p = 0,0032 -> das Ergebnis bleibt signifikant.
#
# c) Ohne suppressWarnings() kommt dieselbe Warnung:
chisq.test(c(37, 0), p = c(0.9, 0.1))
#    Grund: Erwartet werden nur 3,7 / 3,9 / 4,0 Ausschussteile, also unter 5.
#    Alle p-Werte aus Aufgabe 4 sind daher nur Näherungen.
#    Die exakte Alternative ist der Binomialtest (Stoff KM5-02):
binom.test(0, 37, p = 0.1)$p.value   # M1: 0,048
binom.test(0, 39, p = 0.1)$p.value   # M2: 0,030
binom.test(6, 40, p = 0.1)$p.value   # M3: 0,287
#    -> gleiche Schlussfolgerung wie in Aufgabe 4.


# ---- 6. Kapitel-Check (Navarro Kap. 12) -------------------------------------

# a) Voraussetzungen:
#    1. Es werden Häufigkeiten gezählt, und jede Beobachtung fällt in genau
#       eine Zelle. -> erfüllt (jedes Teil ist entweder Ausschuss oder nicht)
#    2. Die Beobachtungen sind unabhängig voneinander. -> im Wesentlichen
#       erfüllt; fraglich ist nur, ob Teile aus derselben Charge zusammenhängen.
#    3. Die erwarteten Häufigkeiten sind groß genug (80-%-Regel).
#       -> NICHT erfüllt, darum zusätzlich fisher.test() / binom.test()
#
# b) Unabhängigkeitstest: Hängen zwei Merkmale zusammen (Maschine und
#    Ausschuss)? In R bekommt chisq.test() eine Kreuztabelle: chisq.test(tab)
#    Anpassungstest: Passt EINE Verteilung zu einer vorgegebenen
#    Sollverteilung? In R bekommt chisq.test() einen Vektor und die
#    Sollanteile p: chisq.test(c(34, 6), p = c(0.9, 0.1))
#
# c) Nein. Der Unabhängigkeitstest (p = 0,0025) sagt nur, DASS sich die
#    Maschinen unterscheiden, aber nicht welche schlecht ist und in welche
#    Richtung. Der Anpassungstest für M3 gegen 10 % ist sogar NICHT
#    signifikant (p = 0,29); auffällig gegenüber der Vorgabe sind nur M1 und
#    M2, und die in die gute Richtung.
