package viewmodel

import "github.com/wagoodman/dive/internal/app/dive/image"

type LayerSelection struct {
	Layer                                                      *image.Layer
	BottomTreeStart, BottomTreeStop, TopTreeStart, TopTreeStop int
}
