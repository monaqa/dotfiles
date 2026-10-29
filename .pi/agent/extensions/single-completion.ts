import { CustomEditor, type ExtensionAPI } from "@earendil-works/pi-coding-agent"
import { getKeybindings, SelectList } from "@earendil-works/pi-tui"

export class SingleCompleteionEditor extends CustomEditor {
  override handleInput(data: string): void {
    if (getKeybindings().matches(data, "tui.input.tab") && this.isShowingAutocomplete() && Reflect.get(this, "isInPaste") !== true) {
      const list: unknown = Reflect.get(this, "autocompleteList");
      if (list instanceof SelectList) {
        const items: unknown = Reflect.get(list, "filteredItems")
        const selected = list.getSelectedItem()
        if ((Array.isArray(items) && items.length === 1 && selected && list.onSelect)) {
          list.onSelect(selected);
          return
        }
      }
    }
    super.handleInput(data)
  }
}

export default function(pi: ExtensionAPI): void {
  pi.on("session_start", (_event, ctx) => {
    if (ctx.mode !== "tui") return
    ctx.ui.setEditorComponent((tui, theme, kb) => new SingleCompleteionEditor(tui, theme, kb))
  })
}
