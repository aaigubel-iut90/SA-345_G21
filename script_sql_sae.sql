DROP TABLE IF EXISTS ligne_panier, ligne_commande, commande, etat, ski, type_ski, longueur, utilisateur;


CREATE TABLE IF NOT EXISTS utilisateur
(
    id_utilisateur INT AUTO_INCREMENT,
    login          VARCHAR(255),
    password       VARCHAR(255),
    role           VARCHAR(255),
    est_actif      TINYINT(1),
    nom            VARCHAR(255),
    email          VARCHAR(255),
    PRIMARY KEY (id_utilisateur)
);

CREATE TABLE IF NOT EXISTS longueur
(
    id_longueur      INT AUTO_INCREMENT,
    libelle_longueur VARCHAR(50),
    PRIMARY KEY (id_longueur)
);

CREATE TABLE IF NOT EXISTS type_ski
(
    id_type_ski      INT AUTO_INCREMENT,
    libelle_type_ski VARCHAR(50),
    PRIMARY KEY (id_type_ski)
);

CREATE TABLE IF NOT EXISTS ski
(
    id_ski              INT AUTO_INCREMENT,
    nom_ski             VARCHAR(100),
    largeur             INT NOT NULL,
    prix_ski            DECIMAL(10, 2),
    longueur_id         INT,
    type_ski_id         INT,
    fournisseur         VARCHAR(50),
    marque              VARCHAR(50),
    conseil_utilisation TEXT,
    image               VARCHAR(255),
    PRIMARY KEY (id_ski),
    FOREIGN KEY (longueur_id) REFERENCES longueur (id_longueur),
    FOREIGN KEY (type_ski_id) REFERENCES type_ski (id_type_ski)
);

CREATE TABLE IF NOT EXISTS etat
(
    id_etat INT PRIMARY KEY,
    libelle VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS commande
(
    id_commande    INT PRIMARY KEY,
    date_achat     DATE NOT NULL,
    utilisateur_id INT,
    etat_id        INT,
    FOREIGN KEY (utilisateur_id) REFERENCES utilisateur (id_utilisateur),
    FOREIGN KEY (etat_id) REFERENCES etat (id_etat)
);

CREATE TABLE IF NOT EXISTS ligne_commande
(
    commande_id INT,
    id_ski      INT,
    prix        DECIMAL(10, 2) NOT NULL,
    quantite    INT            NOT NULL,
    PRIMARY KEY (commande_id, id_ski),
    FOREIGN KEY (commande_id) REFERENCES commande (id_commande),
    FOREIGN KEY (id_ski) REFERENCES ski (id_ski)
);

CREATE TABLE IF NOT EXISTS ligne_panier
(
    utilisateur_id INT,
    id_ski         INT,
    quantite       INT  NOT NULL,
    date_ajout     DATE NOT NULL,
    PRIMARY KEY (utilisateur_id, id_ski),
    FOREIGN KEY (utilisateur_id) REFERENCES utilisateur (id_utilisateur),
    FOREIGN KEY (id_ski) REFERENCES ski (id_ski)
);

INSERT INTO utilisateur(id_utilisateur, login, email, password, role, nom, est_actif)
VALUES (1, 'admin', 'admin@admin.fr',
        'sha256$dPL3oH9ug1wjJqva$2b341da75a4257607c841eb0dbbacb76e780f4015f0499bb1a164de2a893fdbf',
        'ROLE_admin', 'admin', '1'),
       (2, 'client', 'client@client.fr',
        'sha256$1GAmexw1DkXqlTKK$31d359e9adeea1154f24491edaa55000ee248f290b49b7420ced542c1bf4cf7d',
        'ROLE_client', 'client', '1'),
       (3, 'client2', 'client2@client2.fr',
        'sha256$MjhdGuDELhI82lKY$2161be4a68a9f236a27781a7f981a531d11fdc50e4112d912a7754de2dfa0422',
        'ROLE_client', 'client2', '1');

INSERT INTO etat(id_etat, libelle)
VALUES (1, 'en attente'),
       (2, 'expédié'),
       (3, 'validé'),
       (4, 'confirmé');

INSERT INTO type_ski(id_type_ski, libelle_type_ski)
VALUES (1, 'ski_alpin'),
       (2, 'ski_de_fond'),
       (3, 'ski_de_randonnee'),
       (4, 'ski_freestyle'),
       (5, 'ski_freeride'),
       (6, 'ski_carving'),
       (7, 'compétition'),
       (8, 'ski de piste'),
       (9, 'All mountain');

INSERT INTO longueur(id_longueur, libelle_longueur)
VALUES (1, '150'),
       (2, '155'),
       (3, '160'),
       (4, '165'),
       (5, '170'),
       (6, '175'),
       (7, '180'),
       (8, '185'),
       (9, '190'),
       (10, '195');

INSERT INTO ski (id_ski, nom_ski, largeur, prix_ski, longueur_id, type_ski_id, fournisseur, marque, conseil_utilisation,
                 image)
VALUES (1, 'S/RACE GS 12 (and X12)', 68, 950, 6, 7, 'Mountain Gear', 'Salomon',
        'Conçu pour répondre aux besoins des skieurs les plus exigeants, le S/RACE GS 12 est pensé pour vous offrir un maximum de puissance sur les pistes damées. Doté de la technologie innovante Blade, ce ski garantit une stabilité incroyable sous le pied pendant la glisse, tout en restant suffisamment vif pour réagir instantanément et vous permettre d’enchaîner les virages sans jamais ralentir.',
        's_race_gs_12_(and_x12).png'),
       (2, 'MTN 86 CARBON', 86, 630, 4, 3, 'Extreme Sports', 'Salomon',
        'Doté d’un patin de 86 mm, le MTN 86 CARBON de Salomon est conçu pour offrir à la fois l’extrême légèreté que vous recherchez pour les ascensions, et la stabilité et l’accroche infaillibles qu’il vous faut dans les couloirs les plus raides, sur la neige la plus dure. Ce modèle est fabriqué en partie avec des matériaux recyclés et naturels.',
        'mtn_86_carbon.png'),
       (3, 'S/MAX 8 (and M11)', 73, 600, 3, 8, 'Outdoor Adventures', 'Salomon',
        'Quand vous voulez profiter à fond de chaque journée de ski, le S/MAX 8 de Salomon vous permet d’enchaîner les virages carvés en toute confiance. Cet ensemble moderne et performant associe des technologies de pointe pour vous aider à perfectionner votre technique de virage dès le premier jour.',
        's_max_8_(and_m11).png'),
       (4, 'Skis racing unisexe HERO ELITE ST TI KONECT', 92, 990, 2, 1, 'SheShreds Co.', 'Rossignol',
        'Conçu pour les passionnés de compétition, le Hero Elite ST Ti est un ski course inspiré du slalom destiné aux skieurs techniques sur piste à la recherche de virages vifs et incisifs typés slalom. Notre technologie Line Control (LCT) éprouvée en course s''associe à un patin plus étroit de 68 mm et à une ligne de cotes typée virages courts pour offrir vivacité dans les changements de carres, précision et puissance. La technologie LCT supprime les effets de contreflexion pour offrir une stabilité maximale et une trajectoire optimisée tout au long du virage pour une maîtrise totale de la trajectoire. ',
        'hero_elite_st_ti_konect.png'),
       (5, 'Skis de fond unisexe X-IUM SKATING PREMIUM + S3 STIFF', 43, 680, 9, 2, 'Adventure Seeker', 'Rossignol',
        'Gagnez votre place sur le podium ! Ski course de Coupe du Monde pour les athlètes élite, le X-ium Premium Skate + S3 est doté d''une feuille de carbone sur toute la longueur et de technologies de carres éprouvées en compétition. Résultat : un ski ultraléger parfaitement équilibré qui offre une transmission de puissance et une glisse maximales ainsi qu''une accélération fluide. La construction du S3 intègre un flex et un cambre optimisés performants sur les neiges plus chaudes. Ce ski est compatible avec le système de fixation Turnamic® offrant un flex extrêmement naturel et un excellent retour du terrain.',
        'x_ium_skatting_premium_s3_stiff.png'),
       (6, 'Skis de randonnée hommes ESCAPER 97 NANO OPEN', 97, 790, 6, 3, 'Family Sports', 'Rossignol',
        'Le nouvel Escaper 97 Nano est synonyme d''alchimie parfaite entre légèreté et performance en descente. Sa construction haut de gamme ouvre de nouveaux horizons pour les amateurs de touring en descente. Un ski qui fera de l''ascension une vraie partie de plaisir ! ',
        'escaper_97_nano_open.png'),
       (7, 'REDSTER X9 LUCI REVOSHOCK + X 16 VAR', 99.5, 1549.99, 6, 1, 'Extreme Rides', 'Atomic',
        'L édition spéciale Atomic Redster X9RS Revoshock S Luci, conçu par le légendaire coureur de Coupe du Monde Lucas Braathen, garantit des performances optimales pour les skieurs de tous les jours.',
        'redster_97_nano_open.png'),
       (8, 'MAVERICK 115 CTI', 128, 859.99, 8, 9, 'Speed Seeker', 'Atomic',
        'Proven on the Freeride World Tour, the all-terrain Atomic Maverick 115 CTI delivers hard-charging freeride performance with off-piste versatility.',
        'maverick_115_cti.png'),
       (9, 'BENT CHETLER 120', 133, 799.99, 8, 4, 'SheShreds Co.', 'Atomic',
        'Constantly driving freeride skiing forward, the iconic Atomic Bent Chetler 120 evolves with a new core profile for more float, balance, and playfulness.',
        'bent_chetler_120.png'),
       (10, 'KORE X 90 All Mountain Ski', 91, 700, 5, 9, 'Precision Skis', 'Head',
        'Que ce soit pour foncer à bloc ou glisser tranquillement, le KORE X 90 conviendra à tous les profils de skieurs all-mountain.',
        'kore_x_90.png'),
       (11, 'KORE 117 Freeride Ski', 117, 1000, 8, 5, 'Extreme Sports', 'Head',
        'Le KORE 117 possède la stabilité et la flottaison nécessaires pour filer en ligne droite ou créer de belles gerbes dans des tas de poudreuse.',
        'kore_117.png'),
       (12, 'Oblivion 116 Freestyle Ski', 116, 700, 7, 4, 'Adventure Seeker', 'Head',
        'L''Oblivion 116, ski signature du freerider d''élite Cole Richardson, allie le côté ludique d''un ski à double spatule et un peu de puissance pour garantir entrain et stabilité à pleine vitesse.',
        'oblivion_116.png'),
       (13, 'RC4 WORLDCUP SL MEN M-PLATE ', 78, 1000, 4, 7, 'Mountain Explorer', 'Fischer',
        'Une puissance totale, un changement de carre parfait, une descente comme sur des rails - avec le RC4 Worldcup SL, c''est exactement ce que l''on obtient. Le ski est conforme aux règlements de la FIS et assure, grâce à la nouvelle plaque M, une transmission de force et une accélération ultimes. Avec le RC4 Podium, une chaussure de course de première classe avec une forme de Coupe du monde, le paquet est complété de manière optimale ! ',
        'rc4.png'),
       (14, 'RC ONE 82 GT', 120, 880, 4, 9, 'Young Shredders', 'Fischer',
        'Un ski sportif pour des utilisations ludiques : Le RC One 82 GT. Avec sa construction stable en Titanal de 0,5 mm, ce ski est fait pour les sportifs qui aiment laisser le ski tirer sur la carre avec une accroche optimale. De plus, le Triple Radius permet une conduite dynamique et la Turn Zone unique offre une fluidité maximale - pour des performances équilibrées à toutes les vitesses. ',
        'rc_one_82.png'),
       (15, 'RANGER 116 - BIG STIX ', 112, 850, 8, 6, 'Speed Racer', 'Fischer',
        'Le Ranger 116 est notre vision du Big Mountain moderne et répond aux exigences de tous les freeriders qui ne jurent que par les superlatifs. Les détails techniques et les matériaux robustes de ce ski ont été conçus pour répondre aux exigences des meilleurs freeriders d''aujourd''hui. ',
        'ranger_116.png');
