package runtime

import (
	"github.com/spf13/viper"
	"github.com/wagoodman/dive/internal/app/dive"
)

type Options struct {
	Ci           bool
	Image        string
	Source       dive.ImageSource
	IgnoreErrors bool
	ExportFile   string
	CiConfig     *viper.Viper
	BuildArgs    []string
}
