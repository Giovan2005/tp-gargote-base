<script setup>
import { computed, onMounted, ref } from 'vue'
import { api } from '../api'
import { ariary } from '../utils/format'

const props = defineProps({
  modifiable: { type: Boolean, default: false },
  plats: { type: Array, default: () => [] },
})
const emit = defineEmits(['choisir'])

const platDuJour = ref(null)
const choix = ref('')
const message = ref(null)
const historique = ref([])
const afficherHistorique = ref(false)

// Seuls les plats disponibles peuvent être choisis.
const disponibles = computed(() => props.plats.filter((p) => p.disponible))

async function charger() {
  try {
    platDuJour.value = await api.platDuJour.lire()
  } catch (e) {
    message.value = { type: 'erreur', texte: e.message }
  }
}

async function definir() {
  if (choix.value === '') return
  message.value = null
  try {
    platDuJour.value = await api.platDuJour.definir(Number(choix.value))
    message.value = { type: 'succes', texte: 'Plat du jour mis à jour.' }
  } catch (e) {
    // Par exemple 409 : le plat est épuisé.
    message.value = { type: 'erreur', texte: e.message }
  }
}

async function basculerHistorique() {
  afficherHistorique.value = !afficherHistorique.value
  if (!afficherHistorique.value) return
  try {
    historique.value = await api.platDuJour.historique()
  } catch (e) {
    message.value = { type: 'erreur', texte: e.message }
  }
}

onMounted(charger)
</script>

<template>
  <section class="bandeau-plat-du-jour">
    <h2 class="bandeau-titre">Plat du jour</h2>

    <p v-if="message" class="alerte" :class="`alerte-${message.type}`">{{ message.texte }}</p>

    <div v-if="platDuJour" class="bandeau-contenu">
      <strong>{{ platDuJour.nom }}</strong>
      <span>{{ ariary(platDuJour.prix) }}</span>
      <small v-if="platDuJour.description">{{ platDuJour.description }}</small>
      <button
        v-if="!modifiable"
        class="bouton"
        :disabled="!platDuJour.disponible"
        @click="emit('choisir', platDuJour)"
      >
        Ajouter au panier
      </button>
    </div>
    <p v-else class="vide">Pas encore de plat du jour pour aujourd’hui.</p>

    <div v-if="modifiable" class="bandeau-choix">
      <select v-model="choix">
        <option value="" disabled>Choisir un plat disponible…</option>
        <option v-for="p in disponibles" :key="p.id" :value="p.id">{{ p.nom }}</option>
      </select>
      <button class="bouton" :disabled="choix === ''" @click="definir">Choisir</button>
    </div>

    <button class="lien" @click="basculerHistorique">
      {{ afficherHistorique ? 'Masquer les 7 derniers jours' : 'Voir les 7 derniers jours' }}
    </button>
    <ul v-if="afficherHistorique" class="historique">
      <li v-for="jour in historique" :key="jour.date_jour">
        {{ jour.date_jour }} : {{ jour.nom }}
      </li>
    </ul>
  </section>
</template>