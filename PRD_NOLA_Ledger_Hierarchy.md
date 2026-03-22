# CondoClaw — NOLA Ground Truth, Payment Hierarchy & Excel Ledger Architecture
**PRD Addendum — Module: Financial Engine**
**Version:** 1.0
**Date:** March 22, 2026
**Status:** Active — Supersedes any prior ledger generation spec
**Triggers:** Quintana matter number discrepancy; Palacio validation confirmed correct

---

## Purpose

This module defines the authoritative rules for:
1. How the Excel ledger is constructed (starting point, sheet order, structure)
2. Why the NOLA is the financial ground truth
3. How the statutory payment hierarchy governs how payments are characterized
4. Why the first demand letter must be internally consistent with the NOLA

These rules resolve the class of errors observed in Quintana-type matters where ledger numbers diverge from the NOLA, producing demand letters that are internally inconsistent and legally objectionable.

---

## 1. The NOLA Is the Ground Truth

### 1.1 Principle

The **Notice of Late Assessment (NOLA)** is the authoritative financial starting point for every matter. All system-generated financial records and documents must derive from and remain consistent with the NOLA.

> **The NOLA is not one input among many. It is the anchor. Everything else is derived from it.**

### 1.2 Why This Is the Only Defensible Approach

The NOLA is a formal legal notice sent to the unit owner. Once issued:

- It establishes a declared balance as of a stated date — this is the **baseline balance**
- It triggers statutory rights and obligations (cure period, lien eligibility, etc.)
- It is the document the court will look at first if the matter proceeds to litigation

If the ledger, the statement of account, or the demand letter reflect a different balance than what the NOLA states — even by a small amount — the opposing party will object. The court will question the validity of the entire collections action.

**Inconsistency between the NOLA and the demand letter is inherently objectionable.**

### 1.3 What "Starting from the NOLA" Means in Practice

- The **Excel ledger** begins on the **NOLA date** — not from the first day of delinquency, not from the beginning of the association's fiscal year, not from some arbitrary prior date
- The **opening balance** in the ledger is the **balance stated in the NOLA**
- All subsequent charges, fees, interest, and payments are applied **on top of** that NOLA baseline
- The ledger does not re-litigate what happened before the NOLA — it takes the NOLA as given

### 1.4 Assumption of NOLA Correctness

The system **assumes the NOLA is correct**. This is both a legal and a practical necessity:

- We issued the NOLA. It is our document.
- Challenging our own NOLA in subsequent documents is contradictory and undermines the entire action.
- If the NOLA has an error, the remedy is a corrected NOLA — not a demand letter with different numbers.

**The system must never generate a document that contradicts the NOLA's stated balance.**

### 1.5 What to Do When the NOLA Has Errors

The NOLA may, in some cases, contain errors (e.g., the association misapplied a payment). This is a real complication addressed in §4 below. However:

- The system does not self-correct the NOLA
- The system flags discrepancies for attorney review
- The first demand letter still reflects the NOLA balance — not a corrected figure
- Corrections are addressed through amended NOLAs or litigation, not by changing the demand letter

---

## 2. The Statutory Payment Hierarchy

### 2.1 The Governing Rule — Florida Statute 718.116(3)

When a unit owner makes a payment, **Florida Statute §718.116(3)** dictates the order in which that payment must be applied. The association does not have discretion to apply it differently.

**Mandatory Payment Application Order (§718.116(3)):**

| Priority | Category | Description |
|----------|----------|-------------|
| 1st | **Interest** | Interest accrued on the delinquent assessment |
| 2nd | **Administrative Late Fees** | As authorized by the declaration |
| 3rd | **Costs of Collection** | Including reasonable attorney's fees |
| 4th | **Delinquent Assessments** | Oldest first — the unpaid monthly/special assessments themselves |

> This means a $500 payment from an owner who owes $458 in assessments + $50 in late fees + $25 in interest does NOT pay off the assessment. It first pays the interest, then the late fee, then finally begins to reduce the assessment balance.

### 2.2 Why This Matters

Many associations apply payments incorrectly — they credit the monthly assessment first and leave fees and interest unpaid. This is a statutory violation. When CondoClaw processes the ledger:

1. **We re-apply every payment according to the statutory hierarchy**
2. **The characterization of each line item in the ledger reflects the hierarchy** — not how the association labeled it
3. **The total balance due must still equal the ledger total** — the hierarchy affects characterization, not the sum

### 2.3 Characterization vs. Total

These are separate concepts and must be treated separately:

- **Total balance** = sum of all charges minus sum of all payments = this must be mathematically correct based on the full ledger, and must match the NOLA
- **Characterization** = how each payment is allocated across interest / fees / costs / assessments = this follows the statutory hierarchy, regardless of how the association labeled the transaction

The system may disagree with how the association characterized a payment. That is acceptable. The total must not change.

### 2.4 Practical Example

| Date | Transaction | Association's Label | Correct Statutory Label |
|------|------------|--------------------|-----------------------|
| 03/01/25 | $458.00 charged | Monthly Assessment | Monthly Assessment |
| 03/15/25 | $25.00 charged | Late Fee | Administrative Late Fee |
| 03/20/25 | $15.00 charged | Interest | Interest (18% p.a.) |
| 04/01/25 | $25.00 payment | Payment on Assessment | Applied: $15.00 Interest → $10.00 Late Fee |
| Balance | $473.00 | Same | Same |

The totals are identical. The characterization differs because the payment goes to interest first, then late fee — not to the assessment. The demand letter must reflect the corrected characterization if it itemizes the balance.

### 2.5 Hierarchy Flag

When the system detects that the association applied a payment in a way that conflicts with the statutory hierarchy, it must:

1. **Log a characterization discrepancy** in the compliance checklist
2. **Re-characterize the line item** using the correct hierarchy
3. **Flag for attorney review** — the discrepancy may or may not need to be addressed in court
4. **Note in the compliance checklist**: "Association applied payment contrary to §718.116(3). Re-characterized for compliance. Total unaffected."

The attorney may decide to address this in the demand letter or reserve it for court. The system does not decide — it flags and presents both versions.

---

## 3. Demand Letter Consistency with the NOLA

### 3.1 The Core Rule

> **The first demand letter cannot contradict the NOLA. This is non-negotiable.**

Any document generated after the NOLA must:
- Use the NOLA date as the baseline date
- Use the NOLA balance as the opening balance
- Add only charges that accrued **after** the NOLA date
- Reflect payments received **after** the NOLA date applied per the statutory hierarchy

### 3.2 Permissible Differences Between NOLA and Demand Letter

The demand letter will typically show a **higher** balance than the NOLA because:
- Additional assessments have accrued since the NOLA date
- Additional interest has accrued
- Attorney's fees and costs may have been added (if the matter has progressed)
- Additional late fees may have been added

These differences are expected and acceptable. They must be clearly itemized.

### 3.3 Impermissible Differences

The demand letter must **never** show:
- A lower total than the NOLA (unless a payment was received — which must be shown in the ledger)
- A different opening balance than the NOLA stated
- Charges characterized differently than the NOLA without explanation (e.g., NOLA says "regular assessment" but demand letter says "special assessment")
- Any amount that cannot be traced back to: NOLA baseline + post-NOLA charges − post-NOLA payments

### 3.4 System Validation Gate

Before generating the first demand letter, the system must:

1. Extract the NOLA balance and NOLA date
2. Compare to the ledger opening balance on that date
3. Verify they match within $0.00 tolerance (or flag for review if they differ by any amount)
4. **Block document generation** if the demand letter total cannot be reconciled to: NOLA balance + accruals − payments

This is not a warning. It is a hard block. An inconsistent demand letter must not be generated.

---

## 4. The Complication: When the Association Got It Wrong

### 4.1 Acknowledging the Reality

Associations sometimes misapply payments, miscalculate interest, or categorize charges incorrectly. This creates a genuine tension:

- **The NOLA is assumed correct** (§1.4)
- **The association's ledger characterizations may be wrong** (§2.2)
- **The total must match** (§2.3)
- **Corrections are addressed in court**, not by changing our own documents

### 4.2 How the System Handles This

The system distinguishes between two types of association errors:

**Type A: Characterization Error (payment applied to wrong category)**
- The total is still correct
- The system re-characterizes per hierarchy
- Notes the discrepancy in the compliance checklist
- Does not change the demand letter total
- May be raised in court if the owner contests

**Type B: Mathematical Error (total in NOLA is wrong)**
- This is a NOLA error, not a ledger characterization error
- The system flags a **NOLA Discrepancy Alert**
- Attorney review required before proceeding
- Options: issue a corrected NOLA, or proceed with the NOLA as issued and address in court
- System does not auto-correct the NOLA

### 4.3 The Principle

> **So long as the total amount is correct based on the ledger, the system proceeds. Characterization corrections are noted but do not block the workflow. Mathematical errors block the workflow until reviewed.**

---

## 5. Excel Workbook Architecture

### 5.1 Sheet Order (Mandatory)

Every Excel workbook generated by CondoClaw must follow this exact sheet order:

| Sheet # | Sheet Name | Contents |
|---------|-----------|----------|
| 1 | **Statement of Account** | Summary view — owner, unit, NOLA date, opening balance, all charges/payments, current total due |
| 2 | **Ledger Detail** | Full transaction-by-transaction ledger starting from NOLA date |
| 3 | **Unit Owner Profile** | Owner demographics, property data, association info, occupancy status |
| 4 | **Compliance Checklist** | Step-by-step statutory compliance verification for this matter |

> **The Statement of Account is always Sheet 1.** This is the document the attorney reads first, the document that gets attached to correspondence, and the document the court receives. It must be immediately accessible.

### 5.2 Sheet 1 — Statement of Account

**Purpose:** One-page financial summary. A person unfamiliar with the matter should be able to read this sheet and understand the entire financial picture.

**Required fields:**
- Association name
- Unit owner name and unit number
- Property address
- NOLA date and NOLA balance (clearly labeled as such)
- Itemized charges since NOLA date:
  - Regular assessments (each period listed)
  - Special assessments (if applicable)
  - Interest (rate, period, amount)
  - Administrative late fees
  - Attorney's fees and costs (if applicable)
- Itemized payments received since NOLA date (with dates and statutory allocation)
- **Current Total Amount Due** (bold, prominent)
- As of date (today's date or a specified date)
- Statutory basis: "Pursuant to Florida Statute §718.116"

**Formatting requirements:**
- Charges shown as positive numbers
- Payments shown as negative numbers (or in a separate credit column)
- Running balance column
- Total Due row in bold at bottom
- NOLA row visually distinguished (different background color or bold border)

### 5.3 Sheet 2 — Ledger Detail

**Purpose:** Complete transaction-level audit trail beginning on the NOLA date.

**Required columns:**
- Date
- Description (using statutory terminology — "Monthly Assessment", "Administrative Late Fee", "Interest — 18% per annum", etc.)
- Charge amount
- Payment amount
- Statutory allocation (for payments: shows how payment was split across interest / fees / assessments per §718.116(3))
- Running balance
- Notes / flags (characterization discrepancies, system flags)

**Starting point:**
- Row 1 after headers: NOLA date, "Balance per Notice of Late Assessment", opening balance
- All subsequent rows are post-NOLA transactions
- The opening balance is treated as a single line — it does not re-itemize what happened before the NOLA

**Characterization column:**
- For each payment row, a "Statutory Allocation" column shows: "Interest: $X | Late Fee: $X | Assessment: $X"
- If the association's label conflicts with the statutory hierarchy, both are shown: "Association applied as: [label]. Corrected to: [hierarchy-based allocation]"

### 5.4 Sheet 3 — Unit Owner Profile

**Purpose:** Full profile of the delinquent owner for use in document generation and public records verification.

**Required fields:**
- Owner legal name (as on deed)
- Unit number
- Association name
- Property address (unit)
- Mailing address (if different)
- Ownership verification date (from county appraiser)
- Occupancy status: Owner-occupied / Tenant-occupied / Vacant
- Tenant name (if applicable)
- Monthly assessment amount
- Special assessment amount (if applicable)
- Governing statute: 718 / 720
- Account number (if the association uses one)
- NOLA date and NOLA reference number
- Date of first delinquency (pre-NOLA, for context only)
- Matter ID (CondoClaw internal)

### 5.5 Sheet 4 — Compliance Checklist

**Purpose:** Step-by-step verification that all statutory requirements have been satisfied for this matter. This sheet is the litigation defense document.

**Required checks:**

| # | Check | Status | Date Completed | Notes |
|---|-------|--------|---------------|-------|
| 1 | Correct statute identified (718 vs. 720) | ✓ / ✗ / Pending | | |
| 2 | NOLA issued and date recorded | ✓ / ✗ / Pending | | |
| 3 | NOLA mailed to correct address | ✓ / ✗ / Pending | | |
| 4 | NOLA balance matches ledger opening balance | ✓ / ✗ / Flag | | |
| 5 | Statutory cure period satisfied before demand | ✓ / ✗ / Pending | | |
| 6 | Payment hierarchy applied per §718.116(3) | ✓ / ✗ / Flag | | |
| 7 | Interest rate verified against declaration | ✓ / ✗ / Pending | | |
| 8 | Late fees authorized by declaration | ✓ / ✗ / Pending | | |
| 9 | Attorney fee entitlement confirmed | ✓ / ✗ / Pending | | |
| 10 | Demand letter total consistent with NOLA | ✓ / ✗ / Block | | |
| 11 | Mailing affidavit completed | ✓ / ✗ / Pending | | |
| 12 | Lien eligibility threshold met | ✓ / ✗ / Pending | | |
| 13 | Ownership verified via county appraiser | ✓ / ✗ / Pending | | |
| 14 | Payment characterization discrepancies noted | ✓ / N/A / Flag | | |

**Status legend:**
- ✓ = Complete and verified
- ✗ = Failed / Not satisfied
- Pending = Not yet completed
- Flag = Discrepancy detected — attorney review required
- Block = Hard block — system will not generate next document until resolved

---

## 6. What "Wrong Numbers" Looks Like — Quintana Pattern

The Quintana matter illustrates the failure mode this module is designed to prevent.

**Typical error pattern:**

1. NOLA issued with balance of $X
2. Ledger is constructed starting from an arbitrary prior date (not the NOLA date)
3. Ledger shows a different total because it includes pre-NOLA charges that were not in the NOLA
4. Demand letter uses the ledger total instead of the NOLA-anchored total
5. **Result**: Demand letter contradicts the NOLA → inherently objectionable

**Alternatively:**

1. Association applied a payment to the assessment instead of interest first
2. Ledger reflects the association's characterization
3. Demand letter itemizes interest as still fully outstanding, but ledger shows it was cleared
4. **Result**: Itemization in demand letter is inconsistent with ledger detail → objectionable

**The fix:**
- Start the ledger from the NOLA
- Take the NOLA balance as given
- Re-apply all post-NOLA payments per the statutory hierarchy
- Generate the demand letter from the corrected, NOLA-anchored ledger

---

## 7. Summary Rules — Quick Reference

| Rule | Requirement |
|------|------------|
| Ledger start date | NOLA date (not earlier) |
| Ledger opening balance | NOLA stated balance (exact, no adjustment) |
| Payment allocation | Per §718.116(3) hierarchy regardless of association's label |
| Total balance | Must be mathematically correct per full ledger |
| Demand letter total | Must equal NOLA balance + post-NOLA accruals − post-NOLA payments |
| Demand letter vs. NOLA | Never contradictory. Never lower without showing a payment. |
| Association characterization errors | Re-characterize + flag. Do not change total. |
| Association math errors (NOLA is wrong) | Block. Flag for attorney. Do not generate demand letter. |
| Excel Sheet 1 | Statement of Account |
| Excel Sheet 2 | Ledger Detail |
| Excel Sheet 3 | Unit Owner Profile |
| Excel Sheet 4 | Compliance Checklist |
| NOLA correctness assumption | Yes — system assumes NOLA is correct unless flagged |

---

## 8. Implementation Notes for Development

### 8.1 Ledger Processor Changes (ledger_processor.py)

- Add `nola_date` and `nola_balance` as required inputs to `process_ledger()`
- Filter all transactions: only include rows with date >= NOLA date
- Inject NOLA row as first data row with description = "Balance per Notice of Late Assessment (NOLA)" and amount = NOLA balance
- Add `apply_payment_hierarchy()` function that re-allocates each payment row per §718.116(3):
  - Running totals for: outstanding_interest, outstanding_late_fees, outstanding_costs, outstanding_assessments
  - Each payment reduces them in order
  - Output: per-payment allocation breakdown as additional columns

### 8.2 Excel Output Changes

- Replace single `Ledger` sheet with 4-sheet workbook in the order specified in §5.1
- Sheet 1 (Statement of Account): auto-generated summary from ledger data
- Sheet 2 (Ledger Detail): current ledger output plus statutory allocation columns
- Sheet 3 (Unit Owner Profile): populated from unit_owners database table
- Sheet 4 (Compliance Checklist): auto-populated based on matter state + validation flags

### 8.3 Validation Gate (backend.py — /api/process)

Before generating any demand letter document:
1. Extract NOLA balance from uploaded NOLA document (or from unit_owners/uploads table)
2. Compare to ledger opening balance
3. If delta > $0.00 → return `{"status": "blocked", "reason": "NOLA_LEDGER_MISMATCH", "details": {...}}`
4. If delta == $0.00 → proceed to document generation

### 8.4 Demand Letter Consistency Check (letter_generator.py)

Add pre-generation check:
```
total_from_ledger = sum_of_charges - sum_of_payments (post-NOLA only)
if abs(demand_letter_total - total_from_ledger) > 0.01:
    block("DEMAND_LETTER_INCONSISTENT_WITH_NOLA_LEDGER")
```

---

*This module is referenced from PRD.md §12 (Baseline Excel Ledger) and §8 (Cross-document Validation).*
*Related statutes: Florida Statute §718.116(3) (payment hierarchy), §718.121 (liens).*
