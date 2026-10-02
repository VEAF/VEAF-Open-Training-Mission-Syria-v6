---------------------------------------------------------------------------------------------------------------------------------------------
-- Généré par veaf-tools build depuis mission.yaml
-- Ne pas éditer manuellement.
-- Relancez 'veaf-tools build' ou 'veaf-tools generate-config' pour régénérer.
---------------------------------------------------------------------------------------------------------------------------------------------

-- ── Mission identity ─────────────────────────────────────────────────────────
veaf.config.MISSION_NAME = "VEAF_OpenTraining_Syria_ICAO_LTAG"
veaf.config.era = veaf.ERA.MODERN
veaf.silenceAtcOnAllAirbases()
veaf.HideNamesFromSpawnedGroups = true

veaf.config.language = "fr"

-- ── Global log level ─────────────────────────────────────────────────────────
veaf.ForcedLogLevel = "info"

-- ── CTLD 2 ───────────────────────────────────────────────────────────────────
-- Configuration lives in ctld-config.yaml (edit it with ctld-tools); this only starts it.
veaf.config.manage_airbase_logistics = true
veaf.config.airbase_logistics_radius = 250
veaf.config.airbase_occupation_radius = 2000
veaf.config.airbase_logistics_tick = 30
if ctld then
    veaf.ctld_initialize()
end

-- ── Module configuration + initialization ────────────────────────────────────

-- ── Core ──

if veafRadio then
    veafRadio.initialize(true)
end

if veafShortcuts then
    veafShortcuts.initialize()
end

if veafNamedPoints then
    veafNamedPoints.initialize({})
end

if veafSpawn then
    veafSpawn.initialize()
end

-- ── Combat ──

if veafCarrierOperations then
    veafCarrierOperations.initialize(true)
end

if veafCasMission then
    veafCasMission.initialize()
end

if veafTransportMission then
    veafTransportMission.initialize()
end

if veafCombatMission then
    veafCombatMission.initialize()
    veafCombatMission.addCapMission("CAP-Idlib-MiG29", "CAP rouge MiG-29 (Fox 1) — Idlib — FL220", "Deux MiG-29S armés de R-27R et R-60M patrouillent au-dessus d'Idlib, entre Saraqib et la vallée de l'Oronte, au FL220. Emport : R-60M*4,R-27R*2.", false, true)
    veafCombatMission.addCapMission("CAP-Homs-Su30", "CAP rouge Su-30 (Fox 3) — Homs — FL250", "Deux Su-30 armés de R-77 patrouillent au-dessus de Homs, au FL250. Emport : R-73*4,R-77*6.", false, true)
    veafCombatMission.addCapMission("CAP-Palmyra-MiG31", "CAP rouge MiG-31 (intercepteur haut et rapide) — Palmyre — FL400", "Deux MiG-31 patrouillent haut et vite au-dessus du désert de Palmyre, au FL400. Emport : R-40T*2,R-33*4.", false, true)
    veafCombatMission.addCapMission("CAP-Daraa-Su24", "Raid rouge Su-24 à intercepter — Daraa — FL120", "Deux Su-24M chargés de bombes tournent au nord de Daraa, au FL120, prêts à frapper le front sud : les intercepter. Emport : FAB-500*4,R-60M*2.", false, true)
    veafCombatMission.addCapMission("CAP-Hatay-F16", "CAP bleue F-16 (Fox 3) — Hatay — FL220", "Deux F-16C turcs patrouillent au nord de la frontière, entre Hatay et Gaziantep, au FL220. Emport : AIM-120C*4, AIM-9M*2, Fuel.", false, true)
    veafCombatMission.addCapMission("CAP-Golan-F15", "CAP bleue F-15 (Fox 3) — Golan — FL250", "Deux F-15C israéliens patrouillent à l'ouest du Golan, au FL250. Emport : AIM-9*4,AIM-120*4,Fuel*3.", false, true)
    veafCombatMission.AddMissionsWithSkillAndScale(
        VeafCombatMission:new()
        :setName("Escorte-Tanf")
        :setFriendlyName("Escorte — ravitaillement d'At Tanf")
        :setSecured(false)
        :setRadioMenuEnabled(true)
        :setBriefing([[Un C-130 décolle de Jordanie vers l'enclave d'At Tanf avec du ravitaillement. Une paire de MiG-29S venue de Damas l'attend sur la frontière. Escortez-le jusqu'à l'atterrissage.
Échec si le C-130 est abattu (constaté par vous : la mission ne le vérifie pas).]])
        :addElement(
            VeafCombatMissionElement:new()
            :setName("Transport")
            :setGroups({"SC-Escort-Tanf-C130"})
            :setScalable(false)
        )
        :addElement(
            VeafCombatMissionElement:new()
            :setName("Menace")
            :setGroups({"SC-Escort-Tanf-MiG29"})
            :setScalable(true)
        )
    )
    veafCombatMission.AddMissionsWithSkillAndScale(
        VeafCombatMission:new()
        :setName("Escorte-Safira")
        :setFriendlyName("Escorte — raid F-15E sur Al-Safira")
        :setSecured(false)
        :setRadioMenuEnabled(true)
        :setBriefing([[Deux F-15E partent du sud de la Turquie bombarder le complexe d'Al-Safira (zone Z12). Des Su-30 patrouillent sur Alep. Escortez les F-15E jusqu'à la cible et au retour.
Activez la zone Z12 si vous voulez voir les dépôts détruits.]])
        :addElement(
            VeafCombatMissionElement:new()
            :setName("Frappe")
            :setGroups({"SC-Escort-Safira-F15E"})
            :setScalable(false)
        )
        :addElement(
            VeafCombatMissionElement:new()
            :setName("Menace")
            :setGroups({"SC-Escort-Safira-Su30"})
            :setScalable(true)
        )
    )
    veafCombatMission.AddMissionsWithSkillAndScale(
        VeafCombatMission:new()
        :setName("Interception-Tu22")
        :setFriendlyName("Interception — raid de Tu-22M3 sur Incirlik")
        :setSecured(false)
        :setRadioMenuEnabled(true)
        :setBriefing([[Deux Tu-22M3 escortés de Su-30 partent du centre de la Syrie bombarder Incirlik par le nord d'Alep. Interceptez-les avant le largage.]])
        :addElement(
            VeafCombatMissionElement:new()
            :setName("Bombardiers")
            :setGroups({"SC-Intercept-Tu22"})
            :setScalable(false)
        )
        :addElement(
            VeafCombatMissionElement:new()
            :setName("Escorte")
            :setGroups({"SC-Intercept-Tu22-Escort"})
            :setScalable(true)
        )
    )
    veafCombatMission.AddMissionsWithSkillAndScale(
        VeafCombatMission:new()
        :setName("Interception-VIP")
        :setFriendlyName("Interception — transport VIP de Damas à Hmeimim")
        :setSecured(false)
        :setRadioMenuEnabled(true)
        :setBriefing([[Un IL-76 transporte une délégation de Damas vers la base russe de Hmeimim, escorté par deux MiG-29S. Interceptez-le avant l'atterrissage : la route passe à l'ouest de Homs, dans la couverture des défenses permanentes.]])
        :addElement(
            VeafCombatMissionElement:new()
            :setName("Transport")
            :setGroups({"SC-Intercept-VIP-Il76"})
            :setScalable(false)
        )
        :addElement(
            VeafCombatMissionElement:new()
            :setName("Escorte")
            :setGroups({"SC-Intercept-VIP-Escort"})
            :setScalable(true)
        )
    )
end

if veafCombatZone then
    veafCombatZone.AddZone(
        VeafCombatZone:new()
        :setMissionEditorZoneName("combatZone_Ceyhan_Easy")
        :setFriendlyName("H1 Hélico Ceyhan — facile")
        :setRadioGroupName("Entraînement hélicoptères")
        :setBriefing([[Champ de tir hélicoptères à 8 km à l'est du FARP Ceyhan : cibles inertes (blindés et camions immobiles, tir interdit).
Position : bullseye 346°/141 nm (N36°59.801' E035°56.746'). Ravitailleurs : Arco 1 (panier, TACAN 51Y, 291.0) à 44 nm ; Texaco 1 (perche, TACAN 50Y, 290.0) à 21 nm.]])
        :setTraining(true)
        :initialize()
    )
    veafCombatZone.AddZone(
        VeafCombatZone:new()
        :setMissionEditorZoneName("combatZone_Ceyhan_Medium")
        :setFriendlyName("H2 Hélico Ceyhan — moyen")
        :setRadioGroupName("Entraînement hélicoptères")
        :setBriefing([[Champ de tir hélicoptères de Ceyhan, avec de l'artillerie antiaérienne légère en plus des cibles du niveau facile.
Position : bullseye 346°/141 nm (N36°59.801' E035°56.746'). Ravitailleurs : Arco 1 (panier, TACAN 51Y, 291.0) à 44 nm ; Texaco 1 (perche, TACAN 50Y, 290.0) à 21 nm.]])
        :setTraining(true)
        :initialize()
    )
    veafCombatZone.AddZone(
        VeafCombatZone:new()
        :setMissionEditorZoneName("combatZone_Ceyhan_Hard")
        :setFriendlyName("H3 Hélico Ceyhan — difficile")
        :setRadioGroupName("Entraînement hélicoptères")
        :setBriefing([[Champ de tir hélicoptères de Ceyhan, avec une défense courte portée réaliste : missiles sol-air à guidage infrarouge et lance-missiles portatifs.
Position : bullseye 346°/141 nm (N36°59.801' E035°56.746'). Ravitailleurs : Arco 1 (panier, TACAN 51Y, 291.0) à 44 nm ; Texaco 1 (perche, TACAN 50Y, 290.0) à 21 nm.]])
        :setTraining(true)
        :initialize()
    )
    veafCombatZone.AddZone(
        VeafCombatZone:new()
        :setMissionEditorZoneName("combatZone_Akamas_Easy")
        :setFriendlyName("A1 Attaque Akamas — facile")
        :setRadioGroupName("Entraînement attaque")
        :setBriefing([[Champ de tir air-sol sur la péninsule d'Akamas (ouest de Chypre) : blindés et camions immobiles en tir interdit, dépôt et réservoir.
Position : bullseye 277°/218 nm (N35°00.082' E032°19.364'). Ravitailleurs : Arco 1 (panier, TACAN 51Y, 291.0) à 162 nm ; Texaco 1 (perche, TACAN 50Y, 290.0) à 234 nm.]])
        :setTraining(true)
        :initialize()
    )
    veafCombatZone.AddZone(
        VeafCombatZone:new()
        :setMissionEditorZoneName("combatZone_Akamas_Medium")
        :setFriendlyName("A2 Attaque Akamas — moyen")
        :setRadioGroupName("Entraînement attaque")
        :setBriefing([[Champ de tir d'Akamas : une compagnie blindée et de l'artillerie antiaérienne en plus des cibles du niveau facile.
Position : bullseye 277°/218 nm (N35°00.082' E032°19.364'). Ravitailleurs : Arco 1 (panier, TACAN 51Y, 291.0) à 162 nm ; Texaco 1 (perche, TACAN 50Y, 290.0) à 234 nm.]])
        :setTraining(true)
        :initialize()
    )
    veafCombatZone.AddZone(
        VeafCombatZone:new()
        :setMissionEditorZoneName("combatZone_Akamas_Hard")
        :setFriendlyName("A3 Attaque Akamas — difficile")
        :setRadioGroupName("Entraînement attaque")
        :setBriefing([[Champ de tir d'Akamas : un second groupe blindé et une défense sol-air courte portée à guidage radar.
Position : bullseye 277°/218 nm (N35°00.082' E032°19.364'). Ravitailleurs : Arco 1 (panier, TACAN 51Y, 291.0) à 162 nm ; Texaco 1 (perche, TACAN 50Y, 290.0) à 234 nm.]])
        :setTraining(true)
        :initialize()
    )
    veafCombatZone.AddZone(
        VeafCombatZone:new()
        :setMissionEditorZoneName("combatZone_Karpas_Easy")
        :setFriendlyName("S1 SEAD Karpas — facile")
        :setRadioGroupName("Entraînement SEAD")
        :setBriefing([[Site SEAD de la péninsule de Karpas : une batterie sol-air moyenne portée seule (SA-6 ou SA-11, tirée au sort).
Position : bullseye 296°/126 nm (N35°35.865' E034°22.840'). Ravitailleurs : Arco 1 (panier, TACAN 51Y, 291.0) à 77 nm ; Texaco 1 (perche, TACAN 50Y, 290.0) à 134 nm.]])
        :setTraining(true)
        :initialize()
    )
    veafCombatZone.AddZone(
        VeafCombatZone:new()
        :setMissionEditorZoneName("combatZone_Karpas_Medium")
        :setFriendlyName("S2 SEAD Karpas — moyen")
        :setRadioGroupName("Entraînement SEAD")
        :setBriefing([[Site SEAD de Karpas : la batterie moyenne portée est protégée par une défense courte portée (SA-15, SA-8).
Position : bullseye 296°/126 nm (N35°35.865' E034°22.840'). Ravitailleurs : Arco 1 (panier, TACAN 51Y, 291.0) à 77 nm ; Texaco 1 (perche, TACAN 50Y, 290.0) à 134 nm.]])
        :setTraining(true)
        :initialize()
    )
    veafCombatZone.AddZone(
        VeafCombatZone:new()
        :setMissionEditorZoneName("combatZone_Karpas_Hard")
        :setFriendlyName("S3 SEAD Karpas — difficile")
        :setRadioGroupName("Entraînement SEAD")
        :setBriefing([[Site SEAD de Karpas en réseau Skynet : un radar d'alerte avancée guide les batteries, qui restent éteintes jusqu'au dernier moment.
Position : bullseye 296°/126 nm (N35°35.865' E034°22.840'). Ravitailleurs : Arco 1 (panier, TACAN 51Y, 291.0) à 77 nm ; Texaco 1 (perche, TACAN 50Y, 290.0) à 134 nm.]])
        :setTraining(true)
        :initialize()
    )
    veafCombatZone.AddZone(
        VeafCombatZone:new()
        :setMissionEditorZoneName("combatZone_Saraqib")
        :setFriendlyName("Z01 Front — Saraqib")
        :setRadioGroupName("Front")
        :setBriefing([[Front nord : une brigade mécanisée syrienne tient le carrefour des autoroutes M4 et M5 à Saraqib. Détruire les blindés et l'artillerie ; défense de brigade (artillerie antiaérienne et missiles courte portée).
Position : bullseye 005°/68 nm (N35°51.817' E036°48.188'). Ravitailleurs : Arco 1 (panier, TACAN 51Y, 291.0) à 115 nm ; Texaco 1 (perche, TACAN 50Y, 290.0) à 83 nm.]])
        :initialize()
    )
    veafCombatZone.AddZone(
        VeafCombatZone:new()
        :setMissionEditorZoneName("combatZone_AlBab")
        :setFriendlyName("Z02 Front — Al-Bab")
        :setRadioGroupName("Front")
        :setBriefing([[Front nord-est : des unités syriennes tiennent les abords sud d'Al-Bab. Détruire les blindés et l'infanterie mécanisée ; défense d'artillerie antiaérienne et lance-missiles portatifs.
Position : bullseye 023°/106 nm (N36°22.267' E037°30.864'). Ravitailleurs : Arco 1 (panier, TACAN 51Y, 291.0) à 129 nm ; Texaco 1 (perche, TACAN 50Y, 290.0) à 57 nm.]])
        :initialize()
    )
    veafCombatZone.AddZone(
        VeafCombatZone:new()
        :setMissionEditorZoneName("combatZone_Morek")
        :setFriendlyName("Z03 Front — Morek")
        :setRadioGroupName("Front")
        :setBriefing([[Front centre : un groupement syrien se masse à Morek, sur l'autoroute M5 au nord de Hama. Détruire les blindés et les lance-roquettes ; défense divisionnaire courte portée.
Position : bullseye 000°/39 nm (N35°22.716' E036°41.148'). Ravitailleurs : Arco 1 (panier, TACAN 51Y, 291.0) à 128 nm ; Texaco 1 (perche, TACAN 50Y, 290.0) à 112 nm.]])
        :initialize()
    )
    veafCombatZone.AddZone(
        VeafCombatZone:new()
        :setMissionEditorZoneName("combatZone_Quneitra")
        :setFriendlyName("Z04 Front — Quneitra")
        :setRadioGroupName("Front")
        :setBriefing([[Front sud (Golan) : des blindés syriens se déploient autour de Khan Arnabah, face aux hauteurs du Golan. Détruire les blindés ; défense d'artillerie antiaérienne et lance-missiles portatifs.
Position : bullseye 205°/101 nm (N33°10.998' E035°52.998'). Ravitailleurs : Arco 2 (panier, TACAN 53Y, 293.0) à 69 nm ; Texaco 2 (perche, TACAN 52Y, 292.0) à 92 nm.]])
        :initialize()
    )
    veafCombatZone.AddZone(
        VeafCombatZone:new()
        :setMissionEditorZoneName("combatZone_Daraa")
        :setFriendlyName("Z05 Front — Daraa")
        :setRadioGroupName("Front")
        :setBriefing([[Front sud (frontière jordanienne) : une colonne syrienne se regroupe au nord de Daraa. Détruire les blindés et les camions ; défense d'artillerie antiaérienne.
Position : bullseye 195°/130 nm (N32°37.367' E036°06.406'). Ravitailleurs : Arco 2 (panier, TACAN 53Y, 293.0) à 65 nm ; Texaco 2 (perche, TACAN 52Y, 292.0) à 57 nm.]])
        :initialize()
    )
    veafCombatZone.AddZone(
        VeafCombatZone:new()
        :setMissionEditorZoneName("combatZone_Mhardeh")
        :setFriendlyName("Z06 SEAD — Mhardeh")
        :setRadioGroupName("SEAD")
        :setBriefing([[Site sol-air isolé près de Mhardeh, qui couvre la vallée de l'Oronte : une batterie moyenne portée (SA-6 ou SA-11, tirée au sort) et sa défense rapprochée.
Position : bullseye 350°/32 nm (N35°14.880' E036°34.672'). Ravitailleurs : Arco 1 (panier, TACAN 51Y, 291.0) à 130 nm ; Texaco 1 (perche, TACAN 50Y, 290.0) à 120 nm.]])
        :initialize()
    )
    veafCombatZone.AddZone(
        VeafCombatZone:new()
        :setMissionEditorZoneName("combatZone_Kiswah")
        :setFriendlyName("Z07 SEAD — Al-Kiswah")
        :setRadioGroupName("SEAD")
        :setBriefing([[Site sol-air au sud de Damas, près d'Al-Kiswah : une batterie moyenne portée (SA-6 ou SA-11, tirée au sort) protégée par un Pantsir.
Position : bullseye 197°/85 nm (N33°21.516' E036°14.448'). Ravitailleurs : Arco 2 (panier, TACAN 53Y, 293.0) à 89 nm ; Texaco 2 (perche, TACAN 52Y, 292.0) à 96 nm.]])
        :initialize()
    )
    veafCombatZone.AddZone(
        VeafCombatZone:new()
        :setMissionEditorZoneName("combatZone_ConvoyM5")
        :setFriendlyName("Z08 Convoi — M5")
        :setRadioGroupName("Convois")
        :setBriefing([[Convoi logistique syrien sur l'autoroute M5, de Khan Shaykhun vers Saraqib. L'arrêter avant le front ; il porte sa propre artillerie antiaérienne.
Position : bullseye 357°/43 nm (N35°26.613' E036°38.786'). Ravitailleurs : Arco 1 (panier, TACAN 51Y, 291.0) à 124 nm ; Texaco 1 (perche, TACAN 50Y, 290.0) à 108 nm.]])
        :initialize()
    )
    veafCombatZone.AddZone(
        VeafCombatZone:new()
        :setMissionEditorZoneName("combatZone_ConvoyPalmyra")
        :setFriendlyName("Z09 Convoi — Homs-Palmyre")
        :setRadioGroupName("Convois")
        :setBriefing([[Convoi de carburant sur la route de Homs à Palmyre, de Furqlus vers la base T4. Le détruire avant l'arrivée ; il porte sa propre artillerie antiaérienne.
Position : bullseye 114°/20 nm (N34°36.336' E037°04.536'). Ravitailleurs : Arco 2 (panier, TACAN 53Y, 293.0) à 171 nm ; Texaco 1 (perche, TACAN 50Y, 290.0) à 159 nm.]])
        :initialize()
    )
    veafCombatZone.AddZone(
        VeafCombatZone:new()
        :setMissionEditorZoneName("combatZone_ConvoyEuphrates")
        :setFriendlyName("Z10 Convoi — Euphrate")
        :setRadioGroupName("Convois")
        :setBriefing([[Convoi de ravitaillement sur la route du désert, d'As-Sukhnah vers Deir ez-Zor. Le détruire en route ; il est escorté par un Tunguska.
Position : bullseye 086°/107 nm (N34°53.100' E038°52.500'). Ravitailleurs : Arco 1 (panier, TACAN 51Y, 291.0) à 232 nm ; Texaco 1 (perche, TACAN 50Y, 290.0) à 167 nm.]])
        :initialize()
    )
    veafCombatZone.AddZone(
        VeafCombatZone:new()
        :setMissionEditorZoneName("combatZone_Masyaf")
        :setFriendlyName("Z11 Frappe — Masyaf")
        :setRadioGroupName("Frappes en profondeur")
        :setBriefing([[Centre de recherche et d'assemblage de missiles sol-sol de Masyaf. Détruire l'état-major, le centre de commandement, le hangar et les lanceurs Scud ; défense SA-15 et artillerie antiaérienne.
Position : bullseye 319°/27 nm (N35°03.879' E036°20.448'). Ravitailleurs : Arco 1 (panier, TACAN 51Y, 291.0) à 131 nm ; Texaco 1 (perche, TACAN 50Y, 290.0) à 130 nm.]])
        :initialize()
    )
    veafCombatZone.AddZone(
        VeafCombatZone:new()
        :setMissionEditorZoneName("combatZone_AlSafira")
        :setFriendlyName("Z12 Frappe — Al-Safira")
        :setRadioGroupName("Frappes en profondeur")
        :setBriefing([[Complexe militaire d'Al-Safira, au sud-est d'Alep : dépôts de munitions et de carburant. Tout détruire ; défense SA-8 et missiles courte portée.
Position : bullseye 023°/87 nm (N36°04.749' E037°22.371'). Ravitailleurs : Arco 1 (panier, TACAN 51Y, 291.0) à 131 nm ; Texaco 1 (perche, TACAN 50Y, 290.0) à 72 nm.]])
        :initialize()
    )
    veafCombatZone.AddZone(
        VeafCombatZone:new()
        :setMissionEditorZoneName("combatZone_Jamraya")
        :setFriendlyName("Z13 Frappe — Jamraya")
        :setRadioGroupName("Frappes en profondeur")
        :setBriefing([[Centre de recherche militaire de Jamraya, au nord-ouest de Damas. Détruire les laboratoires, l'état-major et l'antenne ; défense Pantsir, dans la couverture de la défense permanente de Damas.
Position : bullseye 200°/74 nm (N33°34.148' E036°13.865'). Ravitailleurs : Arco 2 (panier, TACAN 53Y, 293.0) à 97 nm ; Texaco 2 (perche, TACAN 52Y, 292.0) à 108 nm.]])
        :initialize()
    )
    veafCombatZone.AddZone(
        VeafCombatZone:new()
        :setMissionEditorZoneName("combatZone_DeirEzZor")
        :setFriendlyName("Z14 Frappe — Deir ez-Zor")
        :setRadioGroupName("Frappes en profondeur")
        :setBriefing([[Tête de pont logistique de Deir ez-Zor sur l'Euphrate : dépôts, camions et bunker. Tout détruire ; défense de missiles courte portée.
Position : bullseye 078°/173 nm (N35°20.280' E040°08.940'). Ravitailleurs : Arco 1 (panier, TACAN 51Y, 291.0) à 271 nm ; Texaco 1 (perche, TACAN 50Y, 290.0) à 189 nm.]])
        :initialize()
    )
    veafCombatZone.AddZone(
        VeafCombatZone:new()
        :setMissionEditorZoneName("combatZone_AbuAlDuhur")
        :setFriendlyName("Z15 OCA — Abu al-Duhur")
        :setRadioGroupName("Bases aériennes")
        :setBriefing([[Base aérienne d'Abu al-Duhur : MiG-23, Su-24 et hélicoptères au parking. Les détruire au sol ; défense SA-6 et artillerie antiaérienne.
Position : bullseye 020°/63 nm (N35°43.888' E037°07.128'). Ravitailleurs : Arco 1 (panier, TACAN 51Y, 291.0) à 132 nm ; Texaco 1 (perche, TACAN 50Y, 290.0) à 91 nm.]])
        :initialize()
    )
    veafCombatZone.AddZone(
        VeafCombatZone:new()
        :setMissionEditorZoneName("combatZone_T4")
        :setFriendlyName("Z16 OCA — T4 (Tiyas)")
        :setRadioGroupName("Bases aériennes")
        :setBriefing([[Base aérienne T4 (Tiyas), en plein désert : avions d'attaque et hélicoptères au parking, abri et centre de commandement. Défense Pantsir et SA-15, dans la couverture d'un SA-6 permanent.
Position : bullseye 107°/47 nm (N34°31.364' E037°36.869'). Ravitailleurs : Arco 2 (panier, TACAN 53Y, 293.0) à 187 nm ; Texaco 2 (perche, TACAN 52Y, 292.0) à 163 nm.]])
        :initialize()
    )
    veafCombatZone.AddZone(
        VeafCombatZone:new()
        :setMissionEditorZoneName("combatZone_TartusPort")
        :setFriendlyName("Z17 Antinavire — port de Tartous")
        :setRadioGroupName("Antinavire")
        :setBriefing([[Base navale russe de Tartous : deux sous-marins, un pétrolier, un bâtiment de débarquement et un cargo à quai, une vedette de patrouille. Les couler ; le port est sous la défense permanente de Tartous (SA-10, Pantsir).
Position : bullseye 286°/43 nm (N34°54.344' E035°52.130'). Ravitailleurs : Arco 1 (panier, TACAN 51Y, 291.0) à 128 nm ; Texaco 1 (perche, TACAN 50Y, 290.0) à 141 nm.]])
        :initialize()
    )
    veafCombatZone.AddZone(
        VeafCombatZone:new()
        :setMissionEditorZoneName("combatZone_RussianFleet")
        :setFriendlyName("Z18 Antinavire — flotte russe")
        :setRadioGroupName("Antinavire")
        :setBriefing([[Groupe naval russe en patrouille au large de Lattaquié : un croiseur Moskva et trois frégates. Les couler ; le croiseur porte une défense sol-air de longue portée navale, à attaquer hors de son enveloppe.
Position : bullseye 309°/82 nm (N35°32.897' E035°23.053'). Ravitailleurs : Arco 1 (panier, TACAN 51Y, 291.0) à 83 nm ; Texaco 1 (perche, TACAN 50Y, 290.0) à 110 nm.]])
        :initialize()
    )
    veafCombatZone.GetZone("combatZone_Ceyhan_Medium"):addZoneElementsFromZoneNamed("combatZone_Ceyhan_Easy")
    veafCombatZone.GetZone("combatZone_Ceyhan_Hard"):addZoneElementsFromZoneNamed("combatZone_Ceyhan_Medium")
    veafCombatZone.GetZone("combatZone_Ceyhan_Hard"):addZoneElementsFromZoneNamed("combatZone_Ceyhan_Easy")
    veafCombatZone.GetZone("combatZone_Akamas_Medium"):addZoneElementsFromZoneNamed("combatZone_Akamas_Easy")
    veafCombatZone.GetZone("combatZone_Akamas_Hard"):addZoneElementsFromZoneNamed("combatZone_Akamas_Medium")
    veafCombatZone.GetZone("combatZone_Akamas_Hard"):addZoneElementsFromZoneNamed("combatZone_Akamas_Easy")
    veafCombatZone.GetZone("combatZone_Karpas_Medium"):addZoneElementsFromZoneNamed("combatZone_Karpas_Easy")
    veafCombatZone.GetZone("combatZone_Karpas_Hard"):addZoneElementsFromZoneNamed("combatZone_Karpas_Medium")
    veafCombatZone.GetZone("combatZone_Karpas_Hard"):addZoneElementsFromZoneNamed("combatZone_Karpas_Easy")
    veafCombatZone.initialize()
end

if veafQraManager then
    veafQraManager.initialize()
    local QRA_Hmeimim = VeafQRA:new()
        :setName("QRA Hmeimim")
        :setCoalition(coalition.side.RED)
        :addEnnemyCoalition(coalition.side.BLUE)
        :setTriggerZone("QRA-Hmeimim")
        :setRandomGroupsToDeployByEnemyQuantity(1, {"QRA-Hmeimim-MiG29", "QRA-Hmeimim-Su27"}, 1)
        :setRandomGroupsToDeployByEnemyQuantity(3, {"QRA-Hmeimim-Su30", "QRA-Hmeimim-MiG31"}, 1)
        :setDelayBeforeRearming(600)
        :setDelayBeforeActivating(90)
        :setAirportLink("Bassel Al-Assad")
        :start()
    local QRA_Damas = VeafQRA:new()
        :setName("QRA Damas")
        :setCoalition(coalition.side.RED)
        :addEnnemyCoalition(coalition.side.BLUE)
        :setTriggerZone("QRA-Damas")
        :setRandomGroupsToDeployByEnemyQuantity(1, {"QRA-Damas-MiG23", "QRA-Damas-MiG29"}, 1)
        :setRandomGroupsToDeployByEnemyQuantity(3, {"QRA-Damas-MiG25", "QRA-Damas-MiG29-Fox3"}, 1)
        :setDelayBeforeRearming(600)
        :setDelayBeforeActivating(90)
        :setAirportLink("Mezzeh")
        :start()
    local QRA_Hatay = VeafQRA:new()
        :setName("QRA Hatay")
        :setCoalition(coalition.side.BLUE)
        :addEnnemyCoalition(coalition.side.RED)
        :setTriggerZone("QRA-Hatay")
        :setRandomGroupsToDeployByEnemyQuantity(1, {"QRA-Hatay-F16", "QRA-Hatay-F4"}, 1)
        :setRandomGroupsToDeployByEnemyQuantity(3, {"QRA-Hatay-F16-Fox3", "QRA-Hatay-F15"}, 1)
        :setDelayBeforeRearming(600)
        :setDelayBeforeActivating(90)
        :setAirportLink("Hatay")
        :start()
    local QRA_Ramat_David = VeafQRA:new()
        :setName("QRA Ramat David")
        :setCoalition(coalition.side.BLUE)
        :addEnnemyCoalition(coalition.side.RED)
        :setTriggerZone("QRA-RamatDavid")
        :setRandomGroupsToDeployByEnemyQuantity(1, {"QRA-RamatDavid-F16", "QRA-RamatDavid-F15"}, 1)
        :setRandomGroupsToDeployByEnemyQuantity(3, {"QRA-RamatDavid-F15-Fox3", "QRA-RamatDavid-F16-Fox3"}, 1)
        :setDelayBeforeRearming(600)
        :setDelayBeforeActivating(90)
        :setAirportLink("Ramat David")
        :start()
end

-- ── Features ──

if veafGrass then
    veafGrass.initialize()
end

if veafAssets then
    veafAssets.Assets = {
        {sort = 1, name = "Overlord 1", description = "Overlord 1 (E-3A) — AWACS nord", information = "U280.0 — FL300 — orbite au nord-est de Gaziantep", linked = "Overlord 1 - Escort"},
        {sort = 2, name = "Magic 1", description = "Magic 1 (E-3A) — AWACS sud", information = "U281.0 — FL310 — orbite au sud de la Jordanie", linked = "Magic 1 - Escort"},
        {sort = 3, name = "Texaco 1", description = "Texaco 1 (KC-135, perche) — nord", information = "TACAN 50Y TX1 — U290.0 — FL220 — piste Osmaniye-Gaziantep", linked = "Texaco 1 - Escort"},
        {sort = 4, name = "Arco 1", description = "Arco 1 (KC-135 MPRS, panier) — nord", information = "TACAN 51Y AR1 — U291.0 — FL180 — piste baie d'Adana", linked = "Arco 1 - Escort"},
        {sort = 5, name = "Texaco 2", description = "Texaco 2 (KC-135, perche) — sud", information = "TACAN 52Y TX2 — U292.0 — FL240 — piste désert jordanien", linked = "Texaco 2 - Escort"},
        {sort = 6, name = "Arco 2", description = "Arco 2 (KC-135 MPRS, panier) — sud", information = "TACAN 53Y AR2 — U293.0 — FL200 — piste côte israélienne", linked = "Arco 2 - Escort"},
        {sort = 7, name = "CSG-74 Stennis", description = "CVN-74 Stennis", information = "TACAN 74X STN — ICLS 11 — Link 4 336.0 — ACLS — U305.0"},
        {sort = 8, name = "CSG-71 Roosevelt", description = "CVN-71 Roosevelt", information = "TACAN 71X RSV — ICLS 12 — Link 4 337.0 — ACLS — U306.0"},
        {sort = 9, name = "ARG-1 Tarawa", description = "LHA-1 Tarawa", information = "TACAN 73X TRW — ICLS 13 — U307.0"},
        {sort = 10, name = "CVN-74 Stennis S3B-Tanker", description = "S-3B Stennis (ravitailleur embarqué)", information = "TACAN 55Y S74 — U295.0"},
        {sort = 11, name = "CVN-71 Roosevelt S3B-Tanker", description = "S-3B Roosevelt (ravitailleur embarqué)", information = "TACAN 56Y S71 — U296.0"},
        {sort = 12, name = "Darkstar 1", description = "Darkstar 1 (E-3A) — AWACS de l'arène", information = "U283.0 — FL300"},
        {sort = 13, name = "Wizard 1", description = "Wizard 1 (A-50) — AWACS rouge", information = "U282.0 — FL300 — orbite entre Hama et Tabqa", linked = "Wizard 1 - Escort"},
        {sort = 14, name = "Shell 1", description = "Shell 1 (IL-78M) — ravitailleur rouge", information = "U294.0 — FL200 — orbite entre T4 et Palmyre", linked = "Shell 1 - Escort"},
        {sort = 15, name = "Focus 1", description = "Focus 1 (A-50) — AWACS rouge de l'arène", information = "U284.0 — FL300"},
        {sort = 16, name = "Reaper 1", description = "Reaper 1 (drone laser) — Ceyhan", information = "Laser 1688 — FM 36.0. 3 000 m sol au-dessus de la zone H ; l'AAA du niveau difficile peut l'abattre : le relancer ici.", jtac = 1688, freq = "36.0", mod = "FM"},
        {sort = 17, name = "Reaper 2", description = "Reaper 2 (drone laser) — Akamas", information = "Laser 1687 — FM 37.0. 3 000 m sol au-dessus de la zone A ; au niveau difficile, le SA-8 porte un peu au-delà des 10 km de marquage.", jtac = 1687, freq = "37.0", mod = "FM"},
    }
    veafAssets.initialize()
end

if veafMove then
    veafMove.initialize()
end

if veafSanctuary then
    veafSanctuary.initialize()
    veafSanctuary.addZone(
        VeafSanctuaryZone:new()
        :setName("Sanctuaire Incirlik")
        :setPolygonFromUnits({"Sanctuaire Incirlik #001", "Sanctuaire Incirlik #002", "Sanctuaire Incirlik #003", "Sanctuaire Incirlik #004", "Sanctuaire Incirlik #005", "Sanctuaire Incirlik #006"})
        :setCoalition(coalition.side.BLUE)
        :setDelayWarning(0)
        :setDelayInstant(60)
        :setProtectFromMissiles(true)
    )
    veafSanctuary.addZone(
        VeafSanctuaryZone:new()
        :setName("Sanctuaire Adana Sakirpasa")
        :setPolygonFromUnits({"Sanctuaire Adana #001", "Sanctuaire Adana #002", "Sanctuaire Adana #003", "Sanctuaire Adana #004", "Sanctuaire Adana #005", "Sanctuaire Adana #006"})
        :setCoalition(coalition.side.BLUE)
        :setDelayWarning(0)
        :setDelayInstant(60)
        :setProtectFromMissiles(true)
    )
    veafSanctuary.addZone(
        VeafSanctuaryZone:new()
        :setName("Sanctuaire Hatay")
        :setPolygonFromUnits({"Sanctuaire Hatay #001", "Sanctuaire Hatay #002", "Sanctuaire Hatay #003", "Sanctuaire Hatay #004", "Sanctuaire Hatay #005", "Sanctuaire Hatay #006"})
        :setCoalition(coalition.side.BLUE)
        :setDelayWarning(0)
        :setDelayInstant(60)
        :setProtectFromMissiles(true)
    )
    veafSanctuary.addZone(
        VeafSanctuaryZone:new()
        :setName("Sanctuaire Gaziantep")
        :setPolygonFromUnits({"Sanctuaire Gaziantep #001", "Sanctuaire Gaziantep #002", "Sanctuaire Gaziantep #003", "Sanctuaire Gaziantep #004", "Sanctuaire Gaziantep #005", "Sanctuaire Gaziantep #006"})
        :setCoalition(coalition.side.BLUE)
        :setDelayWarning(0)
        :setDelayInstant(60)
        :setProtectFromMissiles(true)
    )
    veafSanctuary.addZone(
        VeafSanctuaryZone:new()
        :setName("Sanctuaire Ramat David")
        :setPolygonFromUnits({"Sanctuaire Ramat #001", "Sanctuaire Ramat #002", "Sanctuaire Ramat #003", "Sanctuaire Ramat #004", "Sanctuaire Ramat #005", "Sanctuaire Ramat #006"})
        :setCoalition(coalition.side.BLUE)
        :setDelayWarning(0)
        :setDelayInstant(60)
        :setProtectFromMissiles(true)
    )
    veafSanctuary.addZone(
        VeafSanctuaryZone:new()
        :setName("Sanctuaire Tel Nof")
        :setPolygonFromUnits({"Sanctuaire Tel #001", "Sanctuaire Tel #002", "Sanctuaire Tel #003", "Sanctuaire Tel #004", "Sanctuaire Tel #005", "Sanctuaire Tel #006"})
        :setCoalition(coalition.side.BLUE)
        :setDelayWarning(0)
        :setDelayInstant(60)
        :setProtectFromMissiles(true)
    )
    veafSanctuary.addZone(
        VeafSanctuaryZone:new()
        :setName("Sanctuaire Muwaffaq Salti")
        :setPolygonFromUnits({"Sanctuaire Muwaffaq #001", "Sanctuaire Muwaffaq #002", "Sanctuaire Muwaffaq #003", "Sanctuaire Muwaffaq #004", "Sanctuaire Muwaffaq #005", "Sanctuaire Muwaffaq #006"})
        :setCoalition(coalition.side.BLUE)
        :setDelayWarning(0)
        :setDelayInstant(60)
        :setProtectFromMissiles(true)
    )
    veafSanctuary.addZone(
        VeafSanctuaryZone:new()
        :setName("Sanctuaire King Hussein Air College")
        :setPolygonFromUnits({"Sanctuaire King #001", "Sanctuaire King #002", "Sanctuaire King #003", "Sanctuaire King #004", "Sanctuaire King #005", "Sanctuaire King #006"})
        :setCoalition(coalition.side.BLUE)
        :setDelayWarning(0)
        :setDelayInstant(60)
        :setProtectFromMissiles(true)
    )
    veafSanctuary.addZone(
        VeafSanctuaryZone:new()
        :setName("Sanctuaire Akrotiri")
        :setPolygonFromUnits({"Sanctuaire Akrotiri #001", "Sanctuaire Akrotiri #002", "Sanctuaire Akrotiri #003", "Sanctuaire Akrotiri #004", "Sanctuaire Akrotiri #005", "Sanctuaire Akrotiri #006"})
        :setCoalition(coalition.side.BLUE)
        :setDelayWarning(0)
        :setDelayInstant(60)
        :setProtectFromMissiles(true)
    )
    veafSanctuary.addZone(
        VeafSanctuaryZone:new()
        :setName("Sanctuaire Paphos")
        :setPolygonFromUnits({"Sanctuaire Paphos #001", "Sanctuaire Paphos #002", "Sanctuaire Paphos #003", "Sanctuaire Paphos #004", "Sanctuaire Paphos #005", "Sanctuaire Paphos #006"})
        :setCoalition(coalition.side.BLUE)
        :setDelayWarning(0)
        :setDelayInstant(60)
        :setProtectFromMissiles(true)
    )
    veafSanctuary.addZone(
        VeafSanctuaryZone:new()
        :setName("Sanctuaire At Tanf")
        :setPolygonFromUnits({"Sanctuaire At #001", "Sanctuaire At #002", "Sanctuaire At #003", "Sanctuaire At #004", "Sanctuaire At #005", "Sanctuaire At #006"})
        :setCoalition(coalition.side.BLUE)
        :setDelayWarning(0)
        :setDelayInstant(60)
        :setProtectFromMissiles(true)
    )
    veafSanctuary.addZone(
        VeafSanctuaryZone:new()
        :setName("Sanctuaire FARP Reyhanli")
        :setPolygonFromUnits({"Sanctuaire FARPReyhanli #001", "Sanctuaire FARPReyhanli #002", "Sanctuaire FARPReyhanli #003", "Sanctuaire FARPReyhanli #004", "Sanctuaire FARPReyhanli #005", "Sanctuaire FARPReyhanli #006"})
        :setCoalition(coalition.side.BLUE)
        :setDelayWarning(0)
        :setDelayInstant(60)
        :setProtectFromMissiles(true)
    )
    veafSanctuary.addZone(
        VeafSanctuaryZone:new()
        :setName("Sanctuaire FARP Golan")
        :setPolygonFromUnits({"Sanctuaire FARPGolan #001", "Sanctuaire FARPGolan #002", "Sanctuaire FARPGolan #003", "Sanctuaire FARPGolan #004", "Sanctuaire FARPGolan #005", "Sanctuaire FARPGolan #006"})
        :setCoalition(coalition.side.BLUE)
        :setDelayWarning(0)
        :setDelayInstant(60)
        :setProtectFromMissiles(true)
    )
    veafSanctuary.addZone(
        VeafSanctuaryZone:new()
        :setName("Sanctuaire FARP Ceyhan")
        :setPolygonFromUnits({"Sanctuaire FARPCeyhan #001", "Sanctuaire FARPCeyhan #002", "Sanctuaire FARPCeyhan #003", "Sanctuaire FARPCeyhan #004", "Sanctuaire FARPCeyhan #005", "Sanctuaire FARPCeyhan #006"})
        :setCoalition(coalition.side.BLUE)
        :setDelayWarning(0)
        :setDelayInstant(60)
        :setProtectFromMissiles(true)
    )
    veafSanctuary.addZone(
        VeafSanctuaryZone:new()
        :setName("Sanctuaire Bassel Al-Assad")
        :setPolygonFromUnits({"Sanctuaire Bassel #001", "Sanctuaire Bassel #002", "Sanctuaire Bassel #003", "Sanctuaire Bassel #004", "Sanctuaire Bassel #005", "Sanctuaire Bassel #006"})
        :setCoalition(coalition.side.RED)
        :setDelayWarning(0)
        :setDelayInstant(60)
        :setProtectFromMissiles(true)
    )
    veafSanctuary.addZone(
        VeafSanctuaryZone:new()
        :setName("Sanctuaire Shayrat")
        :setPolygonFromUnits({"Sanctuaire Shayrat #001", "Sanctuaire Shayrat #002", "Sanctuaire Shayrat #003", "Sanctuaire Shayrat #004", "Sanctuaire Shayrat #005", "Sanctuaire Shayrat #006"})
        :setCoalition(coalition.side.RED)
        :setDelayWarning(0)
        :setDelayInstant(60)
        :setProtectFromMissiles(true)
    )
    veafSanctuary.addZone(
        VeafSanctuaryZone:new()
        :setName("Sanctuaire Al-Dumayr")
        :setPolygonFromUnits({"Sanctuaire AlDumayr #001", "Sanctuaire AlDumayr #002", "Sanctuaire AlDumayr #003", "Sanctuaire AlDumayr #004", "Sanctuaire AlDumayr #005", "Sanctuaire AlDumayr #006"})
        :setCoalition(coalition.side.RED)
        :setDelayWarning(0)
        :setDelayInstant(60)
        :setProtectFromMissiles(true)
    )
end

if veafWeather then
    veafWeather.initialize()
end

if veafRemote then
    veafRemote.initialize()
end

if veafAirbases then
    veafAirbases.initialize()
end

-- ── Infrastructure ──

if veafMarkers then
    veafMarkers.initialize()
end

if veafTime then
    veafTime.initialize()
end

if veafUnits then
    veafUnits.initialize()
end

if veafCacheManager then
    veafCacheManager.initialize()
end

if veafEventHandler then
    veafEventHandler.initialize()
end

-- ── Core ──

if veafGroundAI then
    veafGroundAI.initialize()
end

-- ── Infrastructure ──

if veafCommands then
    veafCommands.initialize()
end

-- ── Features ──

if veafInterpreter then
    veafInterpreter.initialize()
end

-- ── Community scripts disabled (VEAF leaves their globals alone) ──────────────
veaf.setConfig("tum", "enable", false)

-- ── Skynet-IADS ──────────────────────────────────────────────────────────────
if veafSkynet then
    veafSkynet.SpotterNetwork = true
    veafSkynet.SpotterView = "off"
    veafSkynet.initialize(false, false, false, false)
end

-- ── CSAR configuration ───────────────────────────────────────────────────────
-- Note: CSAR.lua must be loaded by mission-script.lua before this block.
if csar then
    csar.initialize()
end
