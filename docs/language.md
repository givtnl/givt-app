# Language & Phrasing Guidelines

This document outlines the standard phrasing and terminology used across the Givt application to ensure consistency in all supported languages.

## Core Terminology

The application distinguishes between the **action** of giving, the **object** (the donation itself), and the **context** (e.g., a church collection).

| Concept | English (EN) | Dutch (NL) | German (DE) | Spanish (ES) |
| :--- | :--- | :--- | :--- | :--- |
| **Action (Verb)** | Give | Geven | Geben | Donar / Dar* |
| **Object (Noun)** | Donation | Gift | Spende | Donación |
| **Context** | Collection / Collection Bag | Collecte / Collectebus | Kollekte | Colecta / Recolección |

*\*Note: Spanish uses "Donar" for primary actions (buttons) but may use "Dar" in conversational text (e.g., "Gracias por dar").*

## Phrasing Rules

### 1. The Action: "Give" vs "Donate"
*   **English**: Use **"Give"** for the primary user action (e.g., "Give now", "Give with your phone"). Avoid "Donate" for the action unless referring to the technical transaction.
*   **Dutch**: Use **"Geven"**.
*   **German**: Use **"Geben"**.
*   **Spanish**: Use **"Donar"** for buttons and clear calls to action.

### 2. The Object: "Donation" vs "Gift"
*   **English**: Use **"Donation"** when referring to the transaction (e.g., "Cancel donation", "Max donation amount"). Use "Gift" primarily in the context of "Gift Aid" or specific branding.
*   **Dutch**: Use **"Gift"** consistently for the donation object. When forming compound words with "bedrag" (amount), use the verb form: **"geefbedrag"** (not "giftbedrag") for better natural flow.
*   **German**: Use **"Spende"**.
*   **Spanish**: Use **"Donación"**.

### 3. Tone of Voice
*   **Friendly & Direct**: The app addresses the user directly.
*   **Spanish**: Use **"Tú"** (informal/familiar) consistently (e.g., "tu teléfono", "tu cuenta").
*   **Dutch**: Use **"je/jouw"** (informal) consistently.
*   **German**: Use **"du/dein"** (informal) consistently.
*   **Gratitude**: Messages confirming actions often start with thanks (e.g., "Thanks for giving!").
*   **Clarity**: Error messages should be helpful and polite (e.g., "Oops! Something went wrong").

### 4. Modern & Conversational Language
*   Use contemporary, everyday language that feels natural in conversation.
*   Avoid archaic, overly formal, or bureaucratic phrasing.
*   Prefer active voice and simple, clear vocabulary.

### 5. Capitalization
*   **Sentence case**: Use sentence case for all text elements, including titles, buttons, and labels. Only the first letter of the first word is capitalized (e.g., "Give now", "Cancel donation", "Hé gulle gever").
    *   *Exception*: Proper nouns and brand names (e.g., "Givt", "Bluetooth").

## Data Formatting

### 1. Currency
*   **Rule**: Currency formatting must always respect the user's locale settings.
*   **Details**: Ensure correct symbol placement (prefix vs. suffix) and decimal/thousand separators based on the active locale.

### 2. Dates & Times
*   **Rule**: Dates and times displayed in the UI must be formatted according to the user's locale.
*   **Display**: Use locale-aware formatting to ensure dates match the user's cultural expectations (e.g., day-month vs month-day order).
*   **Internal/API**: Use ISO-8601 or specific fixed formats (e.g., `yyyy-MM-ddTHH:mm:ss`) only for backend communication or logging, never for UI.

## Specific Key Translations

| Key | English | Dutch | German | Spanish |
| :--- | :--- | :--- | :--- | :--- |
| `give` (Button) | Give | Geven | Geben | Donar |
| `cancel` | Cancel | Annuleren | Abbrechen | Cancelar |
| `success` | Success! | Gelukt! | Fertig! | ¡Listo! |
| `loading` | Please wait... | Even geduld... | Bitte warten... | Por favor, espera... |
