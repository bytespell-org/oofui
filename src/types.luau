--!strict

export type IconSpec = string | {
	image: string,
	imageRectOffset: Vector2?,
	imageRectSize: Vector2?,
	scaleType: Enum.ScaleType?,
}

export type ControlSize = "small" | "medium" | "large"
export type ControlVariant = "primary" | "secondary" | "outline" | "ghost" | "destructive"
export type Orientation = "horizontal" | "vertical"

export type CommonControlProps = {
	disabled: boolean?,
	layoutOrder: number?,
	selectionOrder: number?,
	tag: string?,
	rootRef: any?,
}

export type PopoverPlacement =
	"top-start"
	| "top"
	| "top-end"
	| "bottom-start"
	| "bottom"
	| "bottom-end"
	| "left-start"
	| "left"
	| "left-end"
	| "right-start"
	| "right"
	| "right-end"

return {}
