const fs = require("fs");

const root = "C:/Users/beebo/Desktop/ash-oil";
const enemies = JSON.parse(fs.readFileSync(root + "/data/enemy_templates.json", "utf8"));
const lts = JSON.parse(fs.readFileSync(root + "/data/lieutenants.json", "utf8"));
const outDir = root + "/assets/characters";

fs.mkdirSync(outDir, { recursive: true });
const src = fs.readFileSync(root + "/assets/ui/roman/crest.png");

const ids = ["cassian"];
for (const k of Object.keys(lts)) ids.push(k.toLowerCase().replace(/[^a-z0-9]+/g, "_"));
for (const k of Object.keys(enemies)) ids.push(k);

const unique = [...new Set(ids)];
for (const id of unique) {
  fs.writeFileSync(outDir + "/" + id + ".png", src);
}

console.log("Generated portrait placeholders:", unique.length);
