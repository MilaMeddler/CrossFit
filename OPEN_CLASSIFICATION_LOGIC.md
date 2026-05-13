# 🏆 Логика подсчета классификации для CrossFit Open

## 📋 Основная концепция

В формате **Open** спортсмен может **выполнять каждый WOD в разных дивизионах**. Дивизион указывается для каждого результата отдельно (в таблице `scores.division`), а не фиксируется при регистрации.

**Главное отличие от обычного турнира:**
- Обычный турнир: дивизион выбирается 1 раз при регистрации (`tournament_participants.division`)
- Open турнир: дивизион выбирается для каждого WOD отдельно (`scores.division`)

---

## 🎯 Система дивизионов

### Приоритет дивизионов (меньше = лучше):

```
1. Elite         - приоритет 1 (самый сильный)
2. RX            - приоритет 2
3. Intermédiaire - приоритет 3
4. Scaled        - приоритет 4
5. Foundations   - приоритет 5 (начальный уровень)
```

### Важно понимать:

**При сравнении результатов сначала сравнивается дивизион, потом результат!**

Это значит:
- Elite с результатом 10:00 ВСЕГДА выше RX с результатом 5:00
- RX с результатом 100 reps ВСЕГДА выше Scaled с результатом 200 reps
- Дивизион имеет абсолютный приоритет над результатом

### Код приоритета:

```javascript
function divisionPriority(division) {
    if (!division) return 6;
    const d = division.toLowerCase();
    if (d === 'elite') return 1;
    if (d === 'rx') return 2;
    if (d === 'intermediaire' || d === 'inter') return 3;
    if (d === 'scaled' || d === 'scale') return 4;
    if (d === 'foundations') return 5;
    return 6;
}
```

---

## 📝 Типы WOD и сравнение результатов

### 1️⃣ For Time (На время)

**Цель:** Выполнить задание как можно быстрее

**Поля в базе данных:**
- `wod_type = 'time'`
- `value_time` - время выполнения в секундах
- `is_completed` - завершён ли WOD (true/false)
- `value_int` - количество повторений (если не завершён, time cap)
- `tiebreak_time` - время тайбрейка (если не завершён)

**Логика сравнения:**

```javascript
// 1. Завершившие ВСЕГДА лучше не завершивших
if (aCompleted && !bCompleted) return -1; // a лучше
if (!aCompleted && bCompleted) return 1;  // b лучше

// 2. Оба завершили: меньше времени = лучше
if (aCompleted && bCompleted) {
    return timeA - timeB; // 300 сек < 350 сек → первый лучше
}

// 3. Оба НЕ завершили (time cap): больше повторений = лучше
if (!aCompleted && !bCompleted) {
    if (repsA !== repsB) return repsB - repsA; // 95 > 90 → первый лучше
    
    // 4. При равенстве повторений: меньше tiebreak_time = лучше
    return tiebreakA - tiebreakB; // 280 < 290 → первый лучше
}
```

**Примеры:**

| Спортсмен | Результат | is_completed | Ранг | Почему |
|-----------|-----------|--------------|------|---------|
| Анна      | 4:30      | true         | **1** | Завершила, лучшее время |
| Мария     | 5:00      | true         | **2** | Завершила, время хуже |
| Ольга     | 95 reps   | false        | **3** | Не завершила, но больше повторений |
| Елена     | 90 reps (4:50) | false   | **4** | Не завершила, меньше повторений |

**Важно:** 
- ✅ `is_completed = true` означает "выполнил полностью до time cap"
- ❌ `is_completed = false` означает "не успел, достиг time cap"

---

### 2️⃣ AMRAP / Reps (Максимум повторений)

**Цель:** Сделать как можно больше повторений/раундов

**Поля в базе данных:**
- `wod_type = 'reps'`
- `value_int` - целое количество повторений
- `value_decimal` - дробное количество (например, 5.5 раундов)

**Логика сравнения:**

```javascript
// Больше повторений = лучше
const repsA = a.value_int || a.value_decimal || 0;
const repsB = b.value_int || b.value_decimal || 0;
return repsB - repsA; // 150 > 120 → первый лучше
```

**Примеры:**

| Спортсмен | Результат | Ранг | Почему |
|-----------|-----------|------|---------|
| Иван      | 250 reps  | **1** | Больше всех повторений |
| Петр      | 230 reps  | **2** | Меньше чем у Ивана |
| Сергей    | 210 reps  | **3** | Меньше чем у Петра |

**Важно:**
- ⬆️ **Больше = лучше**
- Используется либо `value_int` (целое), либо `value_decimal` (дробное)

---

### 3️⃣ Weight (Вес / 1RM)

**Цель:** Поднять максимальный вес

**Поля в базе данных:**
- `wod_type = 'weight'`
- `value_int` - вес в килограммах (целое)
- `value_decimal` - вес в килограммах (дробное)

**Логика сравнения:**

```javascript
// Больший вес = лучше
const weightA = a.value_int || a.value_decimal || 0;
const weightB = b.value_int || b.value_decimal || 0;
return weightB - weightA; // 120kg > 100kg → первый лучше
```

**Примеры:**

| Спортсмен | Результат | Ранг | Почему |
|-----------|-----------|------|---------|
| Андрей    | 150 kg    | **1** | Самый большой вес |
| Михаил    | 140 kg    | **2** | Меньше чем у Андрея |
| Дмитрий   | 135 kg    | **3** | Меньше чем у Михаила |

**Важно:**
- ⬆️ **Больше = лучше**
- Используется для 1RM (one rep max), тяжелоатлетических движений

---

### 4️⃣ Time + Reps (Комбинированные)

**Поля в базе данных:**
- `wod_type = 'time_reps'`
- `value_time` - основное время
- `value_int` - дополнительные повторения

**Логика:** Зависит от конкретного WOD (обычно как For Time)

---

## 🧮 Алгоритм подсчета - Пошагово

### ШАГ 1: Определение ранга для каждого WOD

Для каждого WOD:

1. **Собираются все результаты** участников (с учётом фильтра по полу)

2. **Результаты сортируются** по функции `compareOpenScores()`:
   ```javascript
   function compareOpenScores(a, b, wod) {
       // ПРИОРИТЕТ 1: Дивизион (elite < rx < scaled)
       const divA = divisionPriority(a.division);
       const divB = divisionPriority(b.division);
       if (divA !== divB) return divA - divB;
       
       // ПРИОРИТЕТ 2: Результат внутри дивизиона
       if (wod.wod_type === 'reps') {
           // AMRAP: больше = лучше
           return repsB - repsA;
       } else {
           // For Time: меньше времени = лучше (с учётом is_completed)
           ...
       }
   }
   ```

3. **Присваивается ранг** - позиция в отсортированном списке

**Пример WOD 1 (For Time, 21-15-9):**

```
Результаты (сырые):
- Мария:  4:00 (RX)
- Анна:   5:30 (Elite)
- Ольга:  6:00 (RX)  
- Елена:  5:00 (Scaled)

Сортировка (сначала дивизион, потом результат):
1. Анна    - 5:30 (Elite)   → Ранг 1 ✅ (Elite приоритет 1)
2. Мария   - 4:00 (RX)      → Ранг 2 (RX приоритет 2, лучше чем Ольга по времени)
3. Ольга   - 6:00 (RX)      → Ранг 3 (RX приоритет 2, хуже Марии по времени)
4. Елена   - 5:00 (Scaled)  → Ранг 4 (Scaled приоритет 4)
```

**Важно:** Анна получила ранг 1, хотя её время (5:30) хуже чем у Марии (4:00), потому что Elite имеет высший приоритет!

---

### ШАГ 2: Определение профиля участника

Профиль определяется по **всем результатам** участника за все WOD:

```javascript
function athleteDivisionProfile(wodScoresData) {
    // 1. Собираем все дивизионы из результатов
    const divisions = Object.values(wodScoresData)
        .filter(d => d.score && d.score.division)
        .map(d => d.score.division.toLowerCase());
    
    // 2. Находим уникальные дивизионы
    const unique = [...new Set(divisions)];
    
    // 3. Если все WOD в одном дивизионе
    if (unique.length === 1) return unique[0]; // 'rx' или 'scaled'
    
    // 4. Если смешанные (mixed) - берём самый высокий
    if (unique.includes('elite')) return 'mixed_elite';
    if (unique.includes('rx')) return 'mixed_rx';
    if (unique.includes('intermediaire')) return 'mixed_intermediaire';
    if (unique.includes('scaled')) return 'mixed_scaled';
    return 'mixed';
}
```

**Примеры профилей:**

| WOD 1 | WOD 2 | WOD 3 | Профиль | Пояснение |
|-------|-------|-------|---------|-----------|
| RX | RX | RX | **rx** | Все WOD в RX = чистый профиль |
| RX | Scaled | RX | **mixed_rx** | Есть RX + другие = смешанный RX |
| Scaled | Scaled | Scaled | **scaled** | Все WOD в Scaled = чистый профиль |
| Elite | RX | Scaled | **mixed_elite** | Есть Elite = смешанный Elite (наивысший) |
| Scaled | Foundations | Scaled | **mixed_scaled** | Scaled + Foundations = смешанный Scaled |
| Intermédiaire | Scaled | Foundations | **mixed_intermediaire** | Inter + младшие = смешанный Inter |

**Визуальные бейджи:**
- `elite` → 🔴 **EL** (красный)
- `mixed_elite` → 🔴 **MX** (светло-красный)
- `rx` → 🟠 **RX** (оранжевый)
- `mixed_rx` → 🟠 **MX** (светло-оранжевый)
- `intermediaire` → 🟣 **IN** (фиолетовый)
- `mixed_intermediaire` → 🟣 **MX** (светло-фиолетовый)
- `scaled` → 🔵 **SC** (синий)
- `mixed_scaled` → 🔵 **MX** (светло-синий)
- `foundations` → 🟢 **F** (зелёный)
- `mixed` → ⚪ **MX** (серый)

---

### ШАГ 3: Подсчет общего балла (Overall)

1. **Суммируются ранги** всех WOD:
   ```javascript
   totalPoints = rank_WOD1 + rank_WOD2 + rank_WOD3 + ...
   ```

2. **Если нет результата** для WOD:
   ```javascript
   rank = totalInCategory; // последнее место в категории
   ```

**Пример (3 WOD, 10 участников в категории):**

```
Анна:
- WOD 1: ранг 1
- WOD 2: ранг 2
- WOD 3: ранг 1
- Total: 1 + 2 + 1 = 4 очка

Мария:
- WOD 1: ранг 2
- WOD 2: нет результата → ранг 10
- WOD 3: ранг 3
- Total: 2 + 10 + 3 = 15 очков
```

**Правило:** Меньше очков = лучше место!

---

### ШАГ 4: Итоговая сортировка (с тайбрейками)

Участники сортируются по **3 уровням тайбрейков**:

#### **Тайбрейк 1: Сумма очков** (меньше = лучше)

```javascript
if (a.totalPoints !== b.totalPoints) {
    return a.totalPoints - b.totalPoints;
}
// 4 очка < 6 очков → первый выше
```

Если сумма одинаковая, переходим к тайбрейку 2.

---

#### **Тайбрейк 2: Приоритет профиля** (меньше = лучше)

**Порядок приоритетов профилей:**

```
Elite (1) > Mixed Elite (2) > RX (3) > Mixed RX (4) >
Intermédiaire (5) > Mixed Inter (6) > Scaled (7) > 
Mixed Scaled (8) > Foundations (9) > Mixed (10)
```

```javascript
function divProfilePriority(profile) {
    if (!profile) return 11;
    const p = profile.toLowerCase();
    if (p === 'elite') return 1;
    if (p === 'mixed_elite') return 2;
    if (p === 'rx') return 3;
    if (p === 'mixed_rx') return 4;
    if (p === 'intermediaire' || p === 'inter') return 5;
    if (p === 'mixed_intermediaire') return 6;
    if (p === 'scaled' || p === 'scale') return 7;
    if (p === 'mixed_scaled') return 8;
    if (p === 'foundations') return 9;
    if (p === 'mixed') return 10;
    return 11;
}

// Сравнение
const profA = divProfilePriority(a.divisionProfile); // rx = 3
const profB = divProfilePriority(b.divisionProfile); // mixed_rx = 4
if (profA !== profB) return profA - profB; // rx выше!
```

**Пример:**
```
Мария:  профиль 'rx' (3)
Ольга:  профиль 'mixed_rx' (4)
→ Мария выше (чистый rx лучше смешанного)
```

Если профили одинаковые, переходим к тайбрейку 3.

---

#### **Тайбрейк 3: Сравнение отсортированных рангов**

Ранги всех WOD сортируются по возрастанию и сравниваются поэлементно:

```javascript
// Ольга: ранги WOD [3, 1, 1] → сортировка [1, 1, 3]
// Елена: ранги WOD [1, 2, 2] → сортировка [1, 2, 2]

for (let i = 0; i < length; i++) {
    if (a.wodRanks[i] !== b.wodRanks[i]) {
        return a.wodRanks[i] - b.wodRanks[i];
    }
}

// i=0: 1 === 1, продолжаем
// i=1: 1 < 2, Ольга выше! ✅
```

**Пример:**
```
Ольга: [3, 1, 1] → sorted [1, 1, 3]
Елена: [1, 2, 2] → sorted [1, 2, 2]

Сравнение:
- Позиция 0: 1 === 1 → равны
- Позиция 1: 1 < 2 → Ольга лучше! ✅
```

**Логика:** У кого раньше встречается меньший ранг, тот выше.

---

## 📊 Полный пример расчета

**Турнир Open с 3 WOD, все дивизионы, Женщины (10 участников):**

### Результаты по WOD:

**WOD 1 (For Time):**
| Участник | Результат | Дивизион | Ранг |
|----------|-----------|----------|------|
| Анна     | 5:30      | RX       | 1    |
| Мария    | 6:00      | RX       | 2    |
| Ольга    | 6:30      | RX       | 3    |
| Елена    | 5:00      | Scaled   | 4    |

**WOD 2 (AMRAP):**
| Участник | Результат | Дивизион | Ранг |
|----------|-----------|----------|------|
| Мария    | 250 reps  | RX       | 1    |
| Ольга    | 180 reps  | Scaled   | 2    |
| Анна     | 240 reps  | RX       | 3    |
| Елена    | 170 reps  | Scaled   | 4    |

**WOD 3 (For Time):**
| Участник | Результат | Дивизион | Ранг |
|----------|-----------|----------|------|
| Ольга    | 4:00      | Scaled   | 1    |
| Анна     | 7:00      | RX       | 2    |
| Елена    | 5:00      | Scaled   | 3    |
| Мария    | 8:00      | RX       | 4    |

### Итоговая таблица:

| Участник | WOD 1 | WOD 2 | WOD 3 | Профиль | Сумма | Ранги (sorted) | Место |
|----------|-------|-------|-------|---------|-------|----------------|-------|
| **Анна** | 1 (rx) | 3 (rx) | 2 (rx) | **rx** | **6** | [1, 2, 3] | **🥇 1** |
| **Мария** | 2 (rx) | 1 (rx) | 4 (rx) | **rx** | **7** | [1, 2, 4] | **🥈 2** |
| **Ольга** | 3 (rx) | 2 (scaled) | 1 (scaled) | **mixed_rx** | **6** | [1, 2, 3] | **🥉 3** |
| **Елена** | 4 (scaled) | 4 (scaled) | 3 (scaled) | **scaled** | **11** | [3, 4, 4] | **4** |

### Разбор расстановки:

#### **1 место: Анна** 
- Сумма: 6 очков
- Профиль: `rx` (чистый)

#### **2 место: Мария**
- Сумма: 7 очков (больше чем у Анны)
- Профиль: `rx` (чистый)

**Почему ниже Анны?**
- Тайбрейк 1: 7 > 6 → Анна выше ✅

---

#### **3 место: Ольга**
- Сумма: 6 очков (равно с Анной!)
- Профиль: `mixed_rx` (смешанный)

**Почему ниже Анны?**
- Тайбрейк 1: 6 = 6 → равны
- Тайбрейк 2: rx (3) < mixed_rx (4) → Анна выше ✅

**Почему ниже Марии?**
- Тайбрейк 1: 6 < 7 → Ольга должна быть выше по сумме!
- Но Мария на 2 месте, потому что чистый `rx` профиль

**СТОП! Пересмотрим:**
На самом деле по логике:
1. Анна: 6 очков, rx → 1 место
2. Ольга: 6 очков, mixed_rx → 2 место (проиграла Анне по тайбрейку 2)
3. Мария: 7 очков, rx → 3 место (больше очков)

Давайте исправлю таблицу:

| Участник | Сумма | Профиль | Ранги | Место | Тайбрейк |
|----------|-------|---------|-------|-------|----------|
| Анна | 6 | rx (3) | [1,2,3] | 🥇 **1** | Меньше очков |
| Ольга | 6 | mixed_rx (4) | [1,2,3] | 🥈 **2** | Равно по очкам, хуже профиль |
| Мария | 7 | rx (3) | [1,2,4] | 🥉 **3** | Больше очков |
| Елена | 11 | scaled (7) | [3,4,4] | **4** | Намного больше очков |

---

## 🔍 Фильтрация по дивизионам

### При фильтре "Все" (all):
```javascript
currentCategory = 'all';
```

- ✅ Показываются **все** участники (независимо от дивизионов)
- ✅ Ранжирование с приоритетом дивизионов
- ✅ Elite всегда выше RX, RX выше Scaled
- ✅ Показываются профили (rx, mixed_rx, scaled, etc.)

**Пример:**
```
1. Анна (Elite) - 10 очков
2. Мария (RX) - 8 очков ← хотя меньше очков, но Elite выше!
3. Ольга (Scaled) - 7 очков
```

---

### При фильтре конкретного дивизиона (например, "RX"):
```javascript
currentCategory = 'rx';
```

- ✅ Показываются **только** участники с чистым профилем `rx`
- ❌ Участники с `mixed_rx` **НЕ показываются**
- ✅ Ранжирование только между RX участниками

**Важно:** Учитываются только те, у кого **ВСЕ** результаты в RX!

```javascript
// Код фильтрации
const myScores = scores.filter(s => s.athlete_id === athlete.id);
if (myScores.length > 0 && !myScores.every(s => s.division === 'rx')) {
    return false; // не включать в фильтр RX
}
```

**Пример:**

Фильтр "RX":
- ✅ Анна (все 3 WOD в RX) → показывается
- ✅ Мария (все 3 WOD в RX) → показывается
- ❌ Ольга (WOD1 в RX, WOD2-3 в Scaled) → НЕ показывается
- ❌ Елена (все в Scaled) → НЕ показывается

Фильтр "Scaled":
- ❌ Анна → НЕ показывается
- ❌ Мария → НЕ показывается
- ❌ Ольга → НЕ показывается (есть RX результат!)
- ✅ Елена (все 3 WOD в Scaled) → показывается

---

## 💎 Ключевые особенности

✅ **Гибкость**: Спортсмен сам выбирает дивизион для каждого WOD  
✅ **Честность**: Elite результат всегда ценнее Scaled (приоритет дивизиона)  
✅ **Профили**: Система различает "чистые" (rx) и "смешанные" (mixed_rx) профили  
✅ **Тайбрейки**: 3 уровня тайбрейков для справедливого определения победителя  
✅ **Прозрачность**: Бейджи показывают профиль участника визуально

---

## 🎨 Визуальное отображение

### В таблице Overall:

```
┌─────┬──────────────────┬────────┬────────┬────────┬───────┐
│ Ранг│ Участник         │ WOD 1  │ WOD 2  │ WOD 3  │ Total │
├─────┼──────────────────┼────────┼────────┼────────┼───────┤
│  1  │ 🔴 RX Анна       │ 5:30   │ 240    │ 7:00   │   6   │
│     │                  │  (rx)  │  (rx)  │  (rx)  │       │
│     │                  │   (1)  │   (3)  │   (2)  │       │
├─────┼──────────────────┼────────┼────────┼────────┼───────┤
│  2  │ 🔴 MX Ольга      │ 6:30   │ 180    │ 4:00   │   6   │
│     │                  │  (rx)  │ (scal) │ (scal) │       │
│     │                  │   (3)  │   (2)  │   (1)  │       │
└─────┴──────────────────┴────────┴────────┴────────┴───────┘
```

**Элементы:**
- 🔴 RX - бейдж чистого профиля RX
- 🔴 MX - бейдж смешанного профиля Mixed RX
- (rx) / (scal) - дивизион конкретного WOD
- (1) / (2) / (3) - ранг в WOD

---

## 📁 Код (ключевые функции)

### leaderboard.html

```javascript
// Основной расчёт для Open
calculateOpenRankings()              // Строка 512
    ↓
    filterParticipants()             // Строка 455 - фильтр по полу/дивизиону
    ↓
    forEach participant:
        forEach wod:
            compareOpenScores()      // Строка 382 - сравнение результатов
            ↓
            присвоить ранг
        ↓
        athleteDivisionProfile()     // Строка 478 - определить профиль
    ↓
    sort by:
        1. totalPoints               // сумма очков
        2. divProfilePriority()      // Строка 595 - приоритет профиля
        3. wodRanks array            // отсортированные ранги
```

### Вспомогательные функции:

```javascript
// Приоритет дивизиона для сравнения результатов
divisionPriority(division)           // Строка 368
    elite: 1, rx: 2, inter: 3, scaled: 4, foundations: 5

// Приоритет профиля для тайбрейка
divProfilePriority(profile)          // Строка 595
    elite: 1, mixed_elite: 2, rx: 3, mixed_rx: 4, ...

// Визуальные бейджи
divisionDot(profile)                 // Строка 495
    elite → 🔴 EL, rx → 🟠 RX, scaled → 🔵 SC, ...
```

---

## 🗄️ Таблицы базы данных

### tournaments
```sql
is_open BOOLEAN              -- true для Open формата
active_divisions TEXT[]      -- ['elite', 'rx', 'intermediaire', 'scaled', 'foundations']
```

### scores
```sql
division VARCHAR             -- дивизион для конкретного результата (Open)
tiebreak_time INTEGER        -- время тайбрейка в секундах
is_completed BOOLEAN         -- завершён ли WOD (For Time)
value_time INTEGER           -- время в секундах
value_int INTEGER            -- повторения или вес (целое)
value_decimal DECIMAL        -- дробные значения
```

### tournament_participants
```sql
division VARCHAR             -- НЕ используется для Open (используется для обычных)
```

---

## ⚠️ Важные нюансы

### 1. Приоритет дивизиона абсолютный

```
Elite 10:00 > RX 5:00
RX 100 reps > Scaled 200 reps
```

Дивизион важнее результата!

### 2. Профили влияют на тайбрейк

```
При равной сумме очков:
rx > mixed_rx > scaled > mixed_scaled
```

Чистый профиль лучше смешанного!

### 3. Фильтр по дивизиону строгий

```
Фильтр "RX" → показывает ТОЛЬКО чистых RX
mixed_rx НЕ показывается!
```

Нужны ВСЕ результаты в одном дивизионе!

### 4. Отсутствие результата = последнее место

```
Если нет результата для WOD:
rank = totalInCategory (последнее место)
```

Пропуск WOD сильно снижает позицию!

---

## 📖 Примеры кода из leaderboard.html

### Сравнение результатов For Time:

```javascript
function compareOpenScores(a, b, wod) {
    // 1. Приоритет дивизиона
    const divA = divisionPriority(a.division); // rx = 2
    const divB = divisionPriority(b.division); // scaled = 4
    if (divA !== divB) return divA - divB;     // 2 < 4, rx выше!
    
    // 2. Результат (For Time)
    const aCompleted = a.is_completed !== false;
    const bCompleted = b.is_completed !== false;
    
    if (aCompleted && bCompleted) {
        // Оба завершили: меньше времени = лучше
        return (a.value_time || 999999) - (b.value_time || 999999);
    } else if (aCompleted && !bCompleted) {
        return -1; // a завершил, b нет → a лучше
    } else if (!aCompleted && bCompleted) {
        return 1;  // b завершил → b лучше
    } else {
        // Оба не завершили: больше reps = лучше
        const repsA = a.value_int || 0;
        const repsB = b.value_int || 0;
        if (repsA !== repsB) return repsB - repsA;
        // При равенстве: меньше tiebreak = лучше
        return (a.tiebreak_time || 999999) - (b.tiebreak_time || 999999);
    }
}
```

### Определение профиля:

```javascript
function athleteDivisionProfile(wodScoresData) {
    // Собираем все дивизионы
    const divisions = Object.values(wodScoresData)
        .map(d => d.score?.division?.toLowerCase())
        .filter(Boolean);
    
    const unique = [...new Set(divisions)];
    
    // Чистый профиль
    if (unique.length === 1) return unique[0]; // 'rx'
    
    // Смешанный профиль (по наивысшему дивизиону)
    if (unique.includes('elite')) return 'mixed_elite';
    if (unique.includes('rx')) return 'mixed_rx';
    if (unique.includes('intermediaire')) return 'mixed_intermediaire';
    if (unique.includes('scaled')) return 'mixed_scaled';
    return 'mixed';
}
```

---

## 🎓 Резюме

**Формат Open — это:**

1. 🎯 **Выбор дивизиона для каждого WOD**
2. 📊 **Приоритет дивизиона над результатом**
3. 🏅 **Профили спортсменов (чистые и смешанные)**
4. ⚖️ **3-уровневая система тайбрейков**
5. 🔍 **Строгая фильтрация по дивизионам**

**Типы WOD:**
- ⏱️ **For Time**: меньше времени = лучше (завершившие > не завершивших)
- 🔁 **AMRAP/Reps**: больше повторений = лучше
- 🏋️ **Weight**: больший вес = лучше

**Ключевая формула успеха:**
```
Место = (сумма рангов ↓) + (профиль ↑) + (лучшие ранги ↑)
```

Где ↓ = меньше лучше, ↑ = выше приоритет лучше.

---

**Файл создан:** 2026-05-13  
**Версия системы:** Унифицированная логика с настраиваемыми дивизионами  
**Код:** `/home/user/CrossFit/leaderboard.html`
