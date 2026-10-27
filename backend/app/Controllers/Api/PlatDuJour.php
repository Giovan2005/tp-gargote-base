<?php

namespace App\Controllers\Api;

use App\Exceptions\RegleMetierException;
use App\Models\PlatDuJourModel;
use App\Services\PlatDuJourService;

class PlatDuJour extends ApiController
{

    public function lire()
    {
        return $this->respond(model(PlatDuJourModel::class)->aujourdhui());
    }

    
    public function definir()
    {
        $donnees = $this->donneesJson();

        try {
            $platDuJour = (new PlatDuJourService())->definir((int) ($donnees['id_plat'] ?? 0));
        } catch (RegleMetierException $e) {
            return $this->erreurMetier($e);
        }

        return $this->respond($platDuJour);
    }

  
    public function historique()
    {
        return $this->respond(model(PlatDuJourModel::class)->historique());
    }
}