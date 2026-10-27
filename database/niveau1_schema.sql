ALTER TABLE plat ADD COLUMN description VARCHAR(255);
ALTER TABLE plat ADD COLUMN disponible BOOLEAN NOT NULL DEFAULT true;
ALTER TABLE plat ADD CONSTRAINT ck_plat_prix CHECK (prix > 0);
ALTER TABLE plat ADD CONSTRAINT uq_plat_nom UNIQUE (nom);

CREATE TABLE plat_du_jour (
    date_jour  DATE PRIMARY KEY,
    id_plat    INTEGER NOT NULL REFERENCES plat(id)
);

ALTER TABLE plat_du_jour OWNER TO gargote;