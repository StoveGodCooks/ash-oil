# ACT 2: SIDE QUESTS (S21–S35)

**12 total side quests organized in three tiers: Early Pressure → Faction Alignment → Ledger Exposure Risk**

---

## TIER 1: EARLY PRESSURE (S21–S24)

### S21: "The Debt Collector" (ECLIPSE)

**Premise:**
Marius corners Cassian after a match. A man owes ECLIPSE 500 gold and has disappeared into the quarries. Marius needs proof of death or proof of relocation (photos, witnesses).

**Reward Options:**
- **Proof of death:** +40 gold, ECLIPSE +3, HEAT +1
- **Proof of relocation:** +40 gold, ECLIPSE +1, HEAT +0
- **Refuse:** ECLIPSE -2, DREAD +1 (Marius warns this "counts against you")

**Investigation Hook:**
Completing this reveals that ECLIPSE tracks men as commodities. Marius Investigation Clue (35% confidence): "ECLIPSE enforcer interested in Cassian for leverage — probably knows about something valuable."

**Rival Impact:**
First encounter with Marius. Sets his tone (amoral, transactional). Relationship score: -2 (refuse) / +1 (relocation) / +2 (death).

**NPC Impact (missions.json):**
```json
{
  "npc_impacts": {
    "Marius": {
      "score": 2,
      "set_flags": ["encountered"],
      "investigation_clue": {
        "rival_id": "marius_enforcer",
        "clue_id": "marius_clue_1_encountered",
        "confidence": 0.35,
        "text": "ECLIPSE enforcer evaluates Cassian as potential asset — pragmatic, transactional interest"
      }
    }
  }
}
```

---

### S22: "The Merchant's Lost Shipment" (AXIOM)

**Premise:**
Nereus sends word: a shipment of quarry stone bound for merchant buyers has been hijacked by a smaller merchant house trying to undercut AXIOM prices. Cassian's job: recover the shipment or destroy it.

**Reward Options:**
- **Recover shipment:** +50 gold, AXIOM +2, RENOWN +1
- **Destroy shipment:** +35 gold, AXIOM +1, HEAT +2 (looks like sabotage)
- **Abandon mission:** AXIOM +0, DREAD +1 (Nereus notes this)

**Investigation Hook:**
Learning AXIOM's supply networks. AXIOM Investigation Clue (40% confidence): "Merchant guilds control resource flows — maybe they control information too?"

**Rival Impact:**
No direct rival contact, but establishes AXIOM's reach and willingness to compete violently.

---

### S23: "The Pit Fighter's Challenge" (Standalone/Lucius consequence)

**Premise:**
Lucius has escaped Arena City and reached Ridge City. He's challenged Cassian to a duel in underground pits. Lucius wants to settle their unfinished business.

**Reward Options:**
- **Accept duel:** Victory: +30 gold, RENOWN +2, Lucius relationship changes (kill = -5, spare = +2). Defeat: -20 gold, HEAT +1.
- **Refuse duel:** +0 gold, Lucius -3 (coward), DREAD +1 (revenge promise)

**Investigation Hook:**
Lucius has tracked Cassian. Why? Lucius Investigation Clue (70% confidence): "Lucius followed you here. Obsessed with settling debts. Carries something (maybe ledger fragment)."

**Rival Impact:**
Lucius escalation. His presence in Ridge City suggests the ledger has spread. If spared, he becomes wildcard in Act 3.

---

### S24: "The State's Inspection" (VEIL)

**Premise:**
A VEIL agent approaches with bureaucratic authority. The ludus is being "inspected for safety violations." But it's pretext to gather intelligence. Cassian can help (informant), obstruct (risky), or disappear.

**Reward Options:**
- **Help (become informant):** +0 gold, VEIL +2, DREAD +2 (compromised)
- **Obstruct:** +0 gold, VEIL -2, HEAT +1
- **Disappear:** +0 gold, HEAT +1, DREAD +1

**Investigation Hook:**
VEIL is actively hunting now. VEIL Investigation Clue (50% confidence): "State security is interested in Cassian — more than standard suspect interest."

**Rival Impact:**
Sets Cassius's tone indirectly. Shows VEIL's surveillance infrastructure.

---

## TIER 2: FACTION ALIGNMENT (S25–S29)

### S25: "The Underground Negotiation" (DAWN)

**Premise:**
Octavian sends Kess: DAWN needs safe passage through ECLIPSE territory. ECLIPSE controls tunnels. Cassian mediates.

**Reward Options:**
- **Negotiate successfully:** +45 gold, DAWN +3, ECLIPSE +1, DREAD +1
- **Side with DAWN:** +45 gold, DAWN +3, ECLIPSE -2, HEAT +2
- **Side with ECLIPSE:** +45 gold, ECLIPSE +2, DAWN -3, DREAD +2 (double agent)

**Investigation Hook:**
DAWN and ECLIPSE reveal factional complexity. DAWN Investigation Clue (55% confidence): "Revolutionary movement has more infrastructure than street gossip suggests."

---

### S26: "The Quarry Accident" (ECLIPSE/VEIL conflict)

**Premise:**
A VEIL agent dies in quarry. Marius claims accident. VEIL claims murder. Cassian investigates and reports to VEIL.

**Reward Options:**
- **Reveal Marius guilty:** +30 gold, VEIL +2, ECLIPSE -3, Cassius Intel (60%), HEAT +1
- **Reveal accident:** +30 gold, VEIL +1, ECLIPSE +2, DREAD +1
- **Refuse investigation:** +0 gold, VEIL -1, ECLIPSE +0, DREAD +1

**Investigation Hook:**
Shows how factions blame each other. Cassius Investigation Clue (60% confidence): "ECLIPSE enforcer willing to kill for less — pragmatic about cleanup."

---

### S27: "The Smuggler's Route" (SPECTER/Neutral)

**Premise:**
Corvus needs someone to test a smuggling route out of Ridge City. Not for escape—for commerce. Cassian walks route, reports safety, identifies checkpoints.

**Reward Options:**
- **Complete safely:** +50 gold, SPECTER +2, escape route known (Act 3 option)
- **Attract guards (test durability):** +50 gold, SPECTER +3, HEAT +2
- **Refuse:** +0 gold, SPECTER +0, DREAD +1

**Investigation Hook:**
Testing escape routes suggests Cassian might flee. SPECTER Investigation Clue (45% confidence): "Information broker testing Cassian's loyalty — or preparing for betrayal."

**Rival Impact:**
Establishes escape from Ridge City is possible (matters for Act 3 solo path).

---

### S28: "The Arrested Priest" (VEIL/PRIESTESS conflict)

**Premise:**
Cult member arrested by VEIL. Priestess wants release. VEIL wants information extraction. Cassian chooses sides.

**Reward Options:**
- **Release prisoner:** +40 gold, PRIESTESS +2, VEIL -2, HEAT +1, DREAD +1 (defied State)
- **Extract info:** +40 gold, VEIL +2, PRIESTESS -2, DREAD +2 (betrayed spirituality)
- **Refuse both:** +0 gold, PRIESTESS -1, VEIL -1, DREAD +2

**Investigation Hook:**
Priestess is organizing. PRIESTESS Investigation Clue (65% confidence): "Cult tracking Cassian — spiritual judgment coming."

**Rival Impact:**
Cassius might appear as VEIL interrogator. Shows he's active.

---

### S29: "The Market Sabotage" (AXIOM/ECLIPSE conflict)

**Premise:**
AXIOM discovers counterfeit goods poisoning contacts. ECLIPSE claims AXIOM framing them. Cassian proves one guilty.

**Reward Options:**
- **Prove ECLIPSE guilty:** +45 gold, AXIOM +2, ECLIPSE -2, HEAT +1
- **Prove AXIOM guilty:** +45 gold, ECLIPSE +2, AXIOM -2, DREAD +1
- **Expose both as conspirators:** +45 gold, AXIOM +0, ECLIPSE +0, RENOWN +2, Marius Intel (70%)

**Investigation Hook:**
Neither faction is unified. Marius Investigation Clue (70% confidence): "ECLIPSE enforcer willing to sabotage competitors — pragmatic, not ideological."

**Rival Impact:**
Marius escalation. Directly aware Cassian navigates faction politics.

---

## TIER 3: LEDGER EXPOSURE RISK (S30–S35)

### S30: "The Informant's Leverage" (VEIL | Cassius Introduction)

**Premise:**
Cassius appears directly for first time. He has evidence Cassian carries something valuable. Demands confirmation. Refuses, he'll extract it (non-lethal but violent).

**Reward Options:**
- **Confirm (become VEIL informant):** +0 gold, VEIL +3, DREAD +3, Cassius +5, Investigation +5%
- **Resist (fight):** +30 gold (if win) or -20 gold (if lose), Cassius +2, HEAT +2, Investigation +3%
- **Flee:** +0 gold, HEAT +3, Cassius becomes active hunter, Investigation +2%

**Investigation Hook:**
Cassius Introduction. Cold, methodical, certain of moral authority. Cassius Investigation Clue (75% confidence): "State agent actively investigating Cassian — knows about leverage."

**Rival Impact:**
Cassius is now active threat. Relationship starts at +2 (respect) or -2 (anger).

---

### S31: "The Ledger Fragment" (Wildcard/Investigation Accelerant)

**Premise:**
Someone—merchant, informant, insider—approaches with ledger fragment. Not whole book. Just pages. Asks: "Is this real? How much is it worth? Can you sell it?"

**Critical moment.** If Cassian sells, he accelerates leak. If refuses, fragment might leak anyway.

**Reward Options:**
- **Sell fragment:** +100 gold, HEAT +2, Investigation +10% (leak accelerates to M15), DREAD +2
- **Refuse and warn silence:** +0 gold, Investigation +8% (hidden but known), DREAD +1
- **Refuse and destroy:** +0 gold, Investigation +5%, DREAD +0

**Investigation Hook:**
THE pivotal side quest. Determines if M16 leak feels random or earned. Fragment Investigation Clue (80% confidence): "Ledger fragments circulating — full book exposure inevitable."

**Rival Impact:**
None direct, but decision shapes whether M16 feels like consequence.

---

### S32: "The Spy in the Ludus" (VEIL/Cassius Hunt)

**Premise:**
Cassius planted informant in ludus (another fighter). Gathering evidence on Cassian. Can identify/turn, silence, or feed false information.

**Reward Options:**
- **Turn informant:** +0 gold, VEIL +0 (they know you're playing), Cassius +1, DREAD +2
- **Silence informant:** +30 gold, VEIL -2, Cassius becomes hostile, HEAT +2
- **Feed false info:** +20 gold, VEIL +0, Cassius +0, DREAD +1, Investigation +2%

**Investigation Hook:**
VEIL's surveillance methods revealed. Cassius Investigation Clue (80% confidence): "State hunter embedded agents everywhere — Cassian tracked constantly."

**Rival Impact:**
Cassius escalation. If turned, he respects you. If silenced, he becomes enemy.

---

### S33: "The Safe Route Activation" (DAWN/Octavian test)

**Premise:**
Octavian wants Cassian to USE smuggling route (S27). Not to escape—to prove he won't. Ideological test of commitment.

**Reward Options:**
- **Use route, return:** +0 gold, DAWN +4 (ultimate trust), DREAD -1, Investigation locked
- **Refuse route:** +0 gold, DAWN +0, DREAD +1
- **Use route, don't return (escape):** +0 gold, HEAT +3, Act 2 ends early with solo path

**Investigation Hook:**
Ideological test. DAWN Investigation Clue (80% confidence): "Revolutionary movement trusts Cassian — or tests him constantly."

**Rival Impact:**
Establishes commitment to DAWN for M18 decision.

---

### S34: "The Aelia Appearance" (VEIL/Aelia Introduction)

**Premise:**
Woman claims to work for Governor directly (above VEIL). Offers off-book deal: work for Governor, undermine VEIL from within, be paid better. Trap or opportunity?

**Reward Options:**
- **Accept:** +60 gold, VEIL -1, Aelia +3, DREAD +2, Investigation locked
- **Refuse (report to VEIL):** +20 gold, VEIL +2, Cassius +1, Aelia becomes hidden enemy
- **Refuse (don't report):** +0 gold, VEIL +0, Aelia +0, DREAD +1

**Investigation Hook:**
Aelia Introduction. Represents something above VEIL. Aelia Investigation Clue (55% confidence): "Someone playing multiple factions — possibly Governor's agent."

**Rival Impact:**
Aelia introduced. Relationship starts neutral (she's testing you).

---

### S35: "The Final Choice Before the Leak" (All factions converge)

**Premise:**
Final side quest before M16. All factions circling. Small opportunity from any of them. Last chance to build relationships.

**Reward Options:**
- **AXIOM job:** +50 gold, AXIOM +2
- **VEIL job:** +40 gold, VEIL +2
- **ECLIPSE job:** +50 gold, ECLIPSE +2
- **DAWN job:** +30 gold, DAWN +2
- **Refuse all:** +0 gold, DREAD +2

**Investigation Hook:**
Last moment before investigation locks. All factions reach 90% confidence. World holds breath.

**Rival Impact:**
Last chance to shift rival relationships before M16 forces everything open.

---

## INVESTIGATION PROGRESS TRACKING

| Side Quest | Investigation Type | Confidence Increase | Running Total |
|---|---|---|---|
| S21 | Marius | 35% | 35% |
| S22 | AXIOM faction | 40% | 40% |
| S23 | Lucius escalation | 70% | 70% |
| S24 | VEIL surveillance | 50% | 50% |
| S25 | DAWN faction | 55% | 55% |
| S26 | Cassius/VEIL | 60% | 60% |
| S27 | SPECTER/escape | 45% | 45% |
| S28 | Priestess/VEIL | 65% | 65% |
| S29 | Marius escalation | 70% | 70% |
| S30 | Cassius direct | 75% | 75% |
| S31 | **Ledger fragment** | **+10%** | **80–90%** |
| S32 | Cassius/VEIL | 80% | 80% |
| S33 | DAWN/Octavian | 80% | 80% |
| S34 | Aelia/Governor | 55% | 55% |
| S35 | All factions | Locks at 90% | 90% |

**After S35, investigation locks at 90%+ confidence. M16 "The Leak" triggers at mission start regardless, but player's choices in side quests determine whether leak feels earned or random.**

---

## SIDE QUEST INTEGRATION WITH M16

**The Leak (M16) happens regardless, but player's Act 2 side quest choices determine:**

1. **HOW** the leak happens:
   - If S31 (Ledger Fragment) was sold: leak accelerates, happens in M15
   - If S31 was refused: leak delayed to M16 proper
   - If S31 was destroyed: leak still happens but mystery who revealed it

2. **WHO** benefits from leak:
   - AXIOM: If favored, they exploit it for merchant leverage
   - VEIL: If favored, they use it for institutional consolidation
   - ECLIPSE: If favored, they profit from chaos
   - DAWN: If favored, they use it as revolutionary weapon

3. **CASSIAN'S POSITION** at M16:
   - High faction alignment (VEIL +5, AXIOM +4, etc.): That faction tries to protect Cassian initially
   - Multiple factions (no clear winner): All turn on Cassian simultaneously
   - DAWN aligned: DAWN tries to hide Cassian but fails (leak is bigger than them)
   - ECLIPSE aligned: ECLIPSE uses Cassian as commodity; offers to sell him out

---

## SIDE QUEST CONSEQUENCES IN ACT 3

**Marius alive:**
- If spared (S21 win): Potential Act 3 ally for ECLIPSE-aligned path
- If killed (defeated in combat): ECLIPSE weakened, loses operational coherence

**Cassius alive:**
- If turned (S30 compromise): Acts as double agent in Act 3, can sabotage VEIL
- If defeated but spared: Possible defection if system shown as corrupt
- If killed: VEIL loses personal hunter, replaces with less-conflicted agent

**Aelia status:**
- If accepted (S34): Governor's handler in Act 3, can leverage her against State
- If refused: Hidden antagonist working against Cassian indirectly
- If never met: Unknown threat until Act 3 reveal

**Lucius alive:**
- If spared (S23): Wildcard ally/enemy in Act 3 (depends on how treated)
- If killed: One rival eliminated, but others remain

**Priestess status:**
- If helped (S28): Cult becomes potential Act 3 ally
- If opposed: Priestess becomes spiritual antagonist, blocks Cult path

---

**End of Act 2 Side Quests Document**
