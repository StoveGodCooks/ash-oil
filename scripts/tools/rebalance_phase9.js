const fs = require("fs");
const path = require("path");

const root = "C:/Users/beebo/Desktop/ash-oil";
const dataDir = path.join(root, "data");

function readJson(file) {
  return JSON.parse(fs.readFileSync(path.join(dataDir, file), "utf8"));
}

function writeJson(file, obj) {
  fs.writeFileSync(path.join(dataDir, file), JSON.stringify(obj, null, 2) + "\n");
}

function missionIndex(id) {
  if (!id.startsWith("M")) return 0;
  return parseInt(id.slice(1), 10);
}

function missionAct(mid) {
  const n = missionIndex(mid);
  if (n <= 7) return 1;
  if (n <= 14) return 2;
  return 3;
}

function sideAct(id) {
  if (["S01", "S14", "S02"].includes(id)) return 1;
  if (["S06", "S13"].includes(id)) return 2;
  return 2;
}

function rewardGold(act, seqInAct, isSide) {
  const base = 50 + act * 20 + seqInAct * 15;
  return isSide ? Math.round(base * 0.65) : base;
}

function effectUtility(effect) {
  if (!effect || effect === "none") return 0;
  const e = String(effect);
  if (e.includes("revive")) return 3.0;
  if (e.includes("execution")) return 2.2;
  if (e.includes("poison_all")) return 2.0;
  if (e.includes("heal_all")) return 1.8;
  if (e.includes("counter")) return 1.4;
  if (e.includes("resource_regen")) return 1.5;
  if (e.includes("next_card_free")) return 1.8;
  if (e.includes("damage_buff")) return 1.3;
  if (e.includes("armor_buff")) return 1.2;
  if (e.includes("draw")) return 1.2;
  if (e.includes("piercing")) return 1.0;
  if (e.includes("poison")) return 1.0;
  if (e.includes("stun")) return 1.0;
  return 0.8;
}

function cardScore(c) {
  const dmg = Number(c.damage || 0);
  const arm = Number(c.armor || 0);
  const heal = Number(c.heal || 0);
  return dmg + arm * 0.9 + heal * 0.85 + effectUtility(c.effect);
}

function cardCostByScore(score, isSignature) {
  if (isSignature) {
    if (score >= 9.2) return 3;
    if (score >= 5.2) return 2;
    return 1;
  }
  if (score >= 9.0) return 3;
  if (score >= 5.0) return 2;
  if (score >= 2.1) return 1;
  return 0;
}

const missions = readJson("missions.json");
const cards = readJson("cards.json");

const sortedMainIds = Object.keys(missions)
  .filter((id) => id.startsWith("M"))
  .sort((a, b) => missionIndex(a) - missionIndex(b));

const actCounters = { 1: 0, 2: 0, 3: 0 };
for (const mid of sortedMainIds) {
  const act = missionAct(mid);
  actCounters[act] += 1;
  const m = missions[mid];
  m.act = act;
  const gold = rewardGold(act, actCounters[act], false);
  m.victory_rewards = m.victory_rewards || {};
  m.retreat_rewards = m.retreat_rewards || {};
  m.victory_rewards.gold = gold;
  m.retreat_rewards.gold = gold;
}

for (const sid of Object.keys(missions).filter((id) => id.startsWith("S")).sort()) {
  const act = sideAct(sid);
  const m = missions[sid];
  m.act = act;
  const seq = Math.max(1, Object.keys(missions).filter((id) => id.startsWith("S")).sort().indexOf(sid) + 1);
  const gold = rewardGold(act, seq, true);
  m.victory_rewards = m.victory_rewards || {};
  m.retreat_rewards = m.retreat_rewards || {};
  m.victory_rewards.gold = gold;
  m.retreat_rewards.gold = gold;
}

for (const [cid, c] of Object.entries(cards)) {
  const score = cardScore(c);
  const cost = cardCostByScore(score, Boolean(c.is_signature));
  c.cost = cost;
  c.power_index = Number((score / 4.2).toFixed(2));
}

writeJson("missions.json", missions);
writeJson("cards.json", cards);
console.log("Phase 9 rebalance applied to missions.json and cards.json");
