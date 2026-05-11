# Portals and Stacking Context

Portals exist primarily because **stacking context cannot be escaped with CSS alone** — not, as commonly cited, because of `overflow: hidden`. Built from Nadia Makarevich's [Positioning and Portals in React](https://www.developerway.com/posts/positioning-and-portals-in-react).

## The stacking context trap

A new stacking context creates a sealed visual layer: anything inside it cannot appear "above" something outside it, no matter how high its `z-index` climbs.

**`position: fixed` is not always relative to the viewport.** If any ancestor creates a stacking context (or a containing block), `position: fixed` is relative to *that*, not the viewport.

### Properties that create a new stacking context

Beyond the well-known `position` + `z-index`:

- `transform` (any value other than `none`)
- `filter`, `backdrop-filter`
- `opacity` < 1
- `will-change` on any of the above
- `contain: layout` / `contain: paint` / `contain: strict`
- `mix-blend-mode` other than `normal`
- `isolation: isolate`
- Position `sticky` + `z-index`
- Flex/grid children with `z-index` set

**Real-world impact (Nadia's testing on 3 popular sites):** the main content area is a trap. Any modal or popup with `position: fixed; z-index: 9999` inside it appears *underneath* the sticky header.

## When to use `createPortal`

```jsx
import { createPortal } from 'react-dom';

function Modal({ children }) {
  return createPortal(
    <div className="modal">{children}</div>,
    document.body
  );
}
```

Use Portals when:
- The element must visually escape its parent's stacking context (modals, popovers, tooltips, dropdowns)
- The element must extend beyond an `overflow: hidden` ancestor
- You need the element near the end of `<body>` for accessibility libraries (focus management, ARIA references)

Don't use Portals when:
- You're solving an `overflow: hidden` clipping issue that could be fixed by moving the element in the DOM
- You're working around a stacking-context bug that should be fixed at the source

## Portal behavior — the two-layer rule

> "What happens in React stays within the React hierarchy. What happens outside of React follows DOM structure rules."

| Behavior | React layer | DOM layer |
|---|---|---|
| Re-renders | Preserved — Portal child re-renders with React parent | — |
| Context (`useContext`) | Works — Portal child reads parent's context | — |
| Synthetic events (`onClick`, etc.) | Bubble through React tree | — |
| CSS inheritance | — | Fails — Portal child inherits from DOM parent (likely `<body>`) |
| Native event listeners | — | Don't catch Portal content (event bubbles in DOM, not React tree) |
| `parentElement` traversal | — | Returns Portal mount point, not React parent |
| Form submission | — | **Breaks** — buttons in a portalled modal don't trigger parent `<form>`'s `onSubmit` |

### The form submission gotcha

```jsx
// ❌ This doesn't work
<form onSubmit={handleSubmit}>
  <input name="x" />
  <Modal>
    <button type="submit">Submit</button>  {/* Won't fire form's onSubmit */}
  </Modal>
</form>
```

The portal mounts the button outside the form in the DOM. Native HTML form submission walks the DOM, not the React tree.

**Fixes:**
1. Use `form="formId"` attribute on the button (HTML's explicit form association):
   ```jsx
   <form id="myForm" onSubmit={handleSubmit}>...</form>
   <Modal>
     <button type="submit" form="myForm">Submit</button>
   </Modal>
   ```
2. Don't portal the submit button — keep it inside the form, portal only the visual content
3. Handle submission programmatically with a callback instead of native form submit

## Positioning patterns

### Tooltips and dropdowns

Use a positioning library — don't roll your own:
- **[Floating UI](https://floating-ui.com/)** (formerly Popper.js) — the standard. Handles flipping, shifting, collision detection across viewports.
- **Radix UI** primitives — built on Floating UI under the hood. Use these for accessible dialogs, popovers, dropdowns, tooltips.
- **CSS Anchor Positioning** (newer) — native browser API, no JS, but browser support is still limited as of 2026.

### Modals and dialogs

Native `<dialog>` element is the modern choice for top-layer rendering:

```jsx
const dialogRef = useRef<HTMLDialogElement>(null);

<dialog ref={dialogRef}>
  <p>Modal content</p>
  <button onClick={() => dialogRef.current?.close()}>Close</button>
</dialog>

// Open: dialogRef.current?.showModal()
```

`<dialog>` advantages:
- Browser-managed top layer — escapes all stacking contexts natively
- `showModal()` traps focus and blocks background interaction
- Closes on `Escape` automatically
- No portal needed

Use cases for portals over `<dialog>`:
- Need React Context / event bubbling through React tree
- Need custom backdrop behavior
- Need non-modal (still-interactive-behind) overlays

## Common pitfalls

- **Assuming `position: absolute` is relative to the viewport** — it's relative to the nearest *positioned* ancestor
- **Assuming `position: fixed` is always relative to the viewport** — `transform` on an ancestor breaks this
- **Adding `z-index: 9999` and hoping** — meaningless if the element is trapped in a stacking context
- **Portalling tooltips that need to read DOM neighbor positions** — they don't share a parent in the DOM, so geometry queries get weird
- **Forgetting accessibility** — portalled modals still need focus trap, `aria-modal`, `aria-labelledby`, and a return-focus target

## Further reading

- [Nadia — Positioning and Portals in React](https://www.developerway.com/posts/positioning-and-portals-in-react)
- [Nadia — Hard React Questions and Modal Dialog](https://www.developerway.com/posts/hard-react-questions-and-modal-dialog)
- [Josh Comeau — What the Heck, z-index??](https://www.joshwcomeau.com/css/stacking-contexts/)
- [Floating UI](https://floating-ui.com/)
- [MDN — `<dialog>`](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/dialog)
