<?php

namespace App\Services;

use App\Exceptions\RegleMetierException;
use App\Models\PlatDuJourModel;
use App\Models\PlatModel;

class PlatDuJourService
{
    /**
     *
     * @throws RegleMetierException
     */
    public function definir(int $idPlat): ?array
    {
        
        $plat = model(PlatModel::class)->find($idPlat);
        if ($plat === null) {
            throw new RegleMetierException('Plat inconnu.', [
                'id_plat' => 'Ce plat n’existe pas.',
            ], 422);
        }

     
        if (! $plat['disponible']) {
            throw new RegleMetierException(
                'Le ' . mb_strtolower($plat['nom']) . ' est épuisé : il ne peut pas être plat du jour.',
                ['id_plat' => 'Ce plat est épuisé.'],
                409
            );
        }

       
        $modele = model(PlatDuJourModel::class);
        $modele->definirAujourdhui($idPlat);

        return $modele->aujourdhui();
    }
}