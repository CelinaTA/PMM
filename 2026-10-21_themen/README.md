# HÜ 2026-10-21 – Themen und Fragestellungen

Drei Themengebiete, die mich interessieren, und die Frage, die ich jeweils an die Daten stellen möchte.

---

## 1. Versuchsplanung – Grip-Spray (Diplomprojekt)

**Frage:** Welches Mischungsverhältnis der Rohstoffe aus unserem Rohstoffkatalog ergibt ein Grip-Spray mit der stabilsten Suspension?

**Warum mich das interessiert:** In unserem Diplomprojekt entwickeln wir ein Grip-Spray. Ein Problem dabei ist, dass sich die Feststoffe absetzen, wenn die Suspension nicht stabil ist. Statt einfach herumzuprobieren, möchte ich die Versuche geplant durchführen.

**Wie man es auswerten könnte:**
- **Faktoren:** die Mengenanteile der Rohstoffe (z. B. Feststoffanteil, Lösungsmittel, Stabilisator/Verdicker), jeweils auf zwei Stufen (wenig/viel)
- **Antwortvariable:** Stabilität der Suspension, z. B. Zeit bis zum sichtbaren Absetzen oder Höhe der Bodensatzschicht nach 24 h
- **Methode:** vollfaktorieller 2^k-Versuch → Haupteffekte und Wechselwirkungen mit `lm()` und `interaction.plot()`; danach eventuell RSM, um das optimale Verhältnis zu finden
- **Daten:** Eigenmaterial, die Messungen mache ich selbst im Rahmen des Diplomprojekts

**Offene Punkte:** Wenn sich alle Anteile auf 100 % summieren, ist das ein Mischungsversuch, weil man dann einen Anteil nicht ändern kann, ohne einen anderen mitzuändern. Wie man das richtig plant, möchte ich klären.

---

## 2. Popkultur – KI-Musik und „Dead Internet“

**Frage:** Wie viel der Musik, die heute gehört wird, ist schon KI-generiert, und merken die Hörer:innen das überhaupt?

**Warum mich das interessiert:** Auf Spotify und Facebook tauchen immer mehr KI-Songs und KI-„Künstler“ auf, die nicht als KI gekennzeichnet sind. Das passt zur „Dead Internet“-Theorie. Mich interessiert, ob z. B. ältere Generationen KI-Songs hören, ohne es zu wissen.

**Wie man es auswerten könnte:**
- **Teilfrage A:** Wie hoch ist der Anteil an KI-Songs in bekannten Playlists oder unter neuen Veröffentlichungen? → Anteil schätzen mit Konfidenzintervall
- **Teilfrage B:** Erkennen Menschen KI-Songs? Eigene kleine Umfrage: Songs vorspielen, „KI oder echt?“ tippen lassen, Alter abfragen → Kontingenztabelle Altersgruppe × richtig erkannt, Chi-Quadrat-Test (`chisq.test()`)
- **Daten:** Zum Teil gibt es Berichte von Streamingdiensten über den Anteil an KI-Uploads. Für Teilfrage B bräuchte man eine eigene Umfrage (Eigenmaterial).

**Offene Punkte:** Es ist schwierig, verlässlich festzustellen, welcher Song KI ist, weil das selten gekennzeichnet wird.

---

## 3. Alltag in Österreich – Nachteulen vs. Lerchen

**Frage:** Wie sind Frühaufsteher (Lerchen) und Nachtmenschen (Eulen) in Österreich verteilt, und sind die einen im Schnitt erfolgreicher als die anderen?

**Warum mich das interessiert:** Man hört oft, dass erfolgreiche Menschen früh aufstehen. Ich möchte wissen, ob das statistisch stimmt oder nur ein Klischee ist.

**Wie man es auswerten könnte:**
- **Verteilung:** Aufsteh- und Schlafzeiten nach Alter, Geschlecht und Beruf → Boxplots mit `ggplot()`
- **Erfolg messbar machen:** z. B. über Einkommen, höchsten Bildungsabschluss oder in unserer Klasse über die Noten
- **Vergleich:** Lerchen vs. Eulen beim Erfolgsmaß → t-Test (`t.test()`); Chronotyp × Bildungsabschluss → Chi-Quadrat-Test
- **Daten:** Zeitverwendungserhebung (Statistik Austria bzw. europäische Zeitverwendungserhebung, siehe F-C13 in `Projekte/fragestellungen-statistik/kuriose-quellen.md`) für Schlafzeiten; für den Zusammenhang mit Erfolg eventuell eine eigene Umfrage

**Offene Punkte:** Selbst wenn Lerchen im Schnitt mehr verdienen, heißt das nicht, dass frühes Aufstehen die *Ursache* ist. Vielleicht zwingen manche Berufe einfach zum frühen Aufstehen (Korrelation ≠ Kausalität).
