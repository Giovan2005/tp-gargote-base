<?php

namespace App\Models;

use CodeIgniter\Model;

class PlatDuJourModel extends Model
{
    protected $table            = 'plat_du_jour';
    protected $primaryKey       = 'date_jour';
    protected $useAutoIncrement = false;
    protected $returnType       = 'array';
    protected $allowedFields    = ['id_plat'];

    public function aujourdhui(): ?array
    {
        $ligne = $this->db->query(
            'SELECT p.id, p.nom, p.prix, p.description, p.disponible, pj.date_jour
             FROM plat_du_jour pj
             JOIN plat p ON p.id = pj.id_plat
             WHERE pj.date_jour = CURRENT_DATE'
        )->getRowArray();

        if ($ligne === null) {
            return null;
        }

        $ligne['id']         = (int) $ligne['id'];
        $ligne['prix']       = (int) $ligne['prix'];
        $ligne['disponible'] = in_array($ligne['disponible'], [true, 't'], true);

        return $ligne;
    }

    
    public function definirAujourdhui(int $idPlat): void
    {
        $this->db->query(
            'INSERT INTO plat_du_jour (date_jour, id_plat) VALUES (CURRENT_DATE, ?)
             ON CONFLICT (date_jour) DO UPDATE SET id_plat = EXCLUDED.id_plat',
            [$idPlat]
        );
    }

   
    public function historique(): array
    {
        $lignes = $this->db->query(
            'SELECT pj.date_jour, p.id, p.nom, p.prix
             FROM plat_du_jour pj
             JOIN plat p ON p.id = pj.id_plat
             WHERE pj.date_jour >= CURRENT_DATE - 6
               AND pj.date_jour <= CURRENT_DATE
             ORDER BY pj.date_jour DESC'
        )->getResultArray();

        foreach ($lignes as &$ligne) {
            $ligne['id']   = (int) $ligne['id'];
            $ligne['prix'] = (int) $ligne['prix'];
        }
        unset($ligne);

        return $lignes;
    }
}