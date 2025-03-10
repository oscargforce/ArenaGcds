# ArenaGCDs Addon WOTLK 3.3.5a 🎮

**ArenaGCDs** is an arena addon designed to track the global cooldowns (GCDs) of **arena1, 2, 3, 4, and 5**. It also displays the ability used as an icon along with a cooldown timer.  
For example, if a Warrior uses **Mortal Strike**, the addon shows a Mortal Strike icon with a **1.5-second cooldown timer** on it.  

![Giphy addon example](https://i.giphy.com/media/v1.Y2lkPTc5MGI3NjExNjJ2am1pZTBrdHdhdW5sM3pneWtsdTY2M3NqYWU5OXFkYmoyeGIxNCZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/OfQ0baTfQeUPJR4hKv/giphy.gif)

---

## ⚙️ Installation Instructions

1. **Download the addon** [from the GitHub release page](https://github.com/oscargforce/ArenaGcds/releases/tag/v1.0.2)
2. **Unzip the file**.
3. Open the unziped folder and move the **`ArenaGCDs`** folder into your WoW Addons directory:  
   - `World of Warcraft/Interface/AddOns/`
4. Restart your game or reload your UI with `/reload`.
5. **Open the Options Panel:**
   - Once in the game, you can open the ArenaGCDs options panel by typing the following command in the chat:
     ```
     /arenagcds
     ```
---

## 🔍 Why Use This Addon?  
This addon helps you:  
- Track **instant abilities** used by arena units.  
- Strategically plan **Scatter/Blind** attacks when opponents are on GCD and unable to counter.  

---

## 🔥 Features  

### GCD Tracking with Instant Spell Cast Procs & Haste Buffs:  
We track the following buffs and procs that affect the GCD:  
- 🧙‍♂️ **Berserking** – Troll racial  
- 💨 **Bloodlust**  
- ✨ **Power Infusion**  
- ❄️ **Icy Veins**  
- ⚔️ **Unholy Presence**  
- 🌪️ **Elemental Mastery**  
- 🔥 **Lava Flows** – Dispelling Flame Shock  
- 💥 **Backdraft** – A Destruction Warlock proc (after **Conflagrate**) reduces GCD to **1 second** for Destruction spells only. Non-Destro spells, like curses, use the default GCD, while spells like **Shadowflame** are reduced to **1 second**.  
- 🩸 **Eradication** – Affliction Warlock proc increases haste by **30%**, reducing GCD to **1 second**.  
- ⚖️ **Judgements of the Pure** – Holy Paladin buff.  

NOTE: **All instant spell cast procs are also being tracked**

### Customizable Settings 🛠️  
- **Drag and Drop**: Move the addon anywhere on the screen.  
- **Timer Font Size**: Adjust the font size of the cooldown timer.  
- **Opacity Control**: Set the opacity of the cooldown shading.  
- **Direction Setting**: Choose the direction of the cooldown animation.  
- **Icon Size**: Customize the size of the ability icons.  

---

## ❌ What This Addon Does NOT Do  
- **Spellcasts**: GCDs are not displayed for spell casts or spell channels.  
  - This is because if the caster cancels the cast during the GCD and doesn’t complete the spell, the GCD also cancels.  
  - Instead, we only listen to the event `UNIT_SPELLCAST_SUCCEEDED` to ensure the unit is on GCD.  

---

Enhance your arena experience and outplay your opponents with **ArenaGCDs**! 🎯
