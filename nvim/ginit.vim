" Make popup menu and tabline look more natural
GuiPopupmenu 0
GuiTabline 0

" Adjust fonts per platform
if has('win32')
	GuiFont consolas:h10
endif
if has('mac')
	GuiFont Courier New:h13
endif
