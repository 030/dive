package view

import "github.com/wagoodman/dive/internal/app/dive/runtime/ui/viewmodel"

type LayerChangeListener func(viewmodel.LayerSelection) error
