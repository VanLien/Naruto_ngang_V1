//go:generate echo $CSVPATH
//go:generate echo $ORMPATH
//go:generate echo $CSV_OUTPUT_PATH
//go:generate go run build_gen.go --csv=$CSVPATH --scheme=$ORMPATH --output=$CSV_OUTPUT_PATH
//-go:generate echo testing
//-go:generate go test tjgame/csv
//-go:generate go test tjgame/document/scheme

package main

import (
	"flag"
	"fmt"
	"tjgame/document/gen"
	"tjgame/server_framework/tj/csv"
)

func main() {
	csvConfig := flag.String("csv", "./config", "input csv directory")
	configCSVOutput := flag.String("output", "config_csv.msgpack", "ouput config_csv directory")
	schemeConfig := flag.String("scheme", "./scheme", "input db scheme directory")
	flag.Parse()

	if len(*csvConfig) > 0 {
		fmt.Println("csv gen...")
		output := "csv/csv.generated.go"
		fmt.Printf("output: %s\n", output)
		if len(*configCSVOutput) > 0 {
			output = output + "+" + *configCSVOutput
			fmt.Printf("output: %s\n", *configCSVOutput)
		}
		csv.Csv2src(*csvConfig, output)
		fmt.Println("csv gen ok")
	}

	if len(*schemeConfig) > 0 {
		fmt.Println("orm gen...")
		gen.Scheme2ORM(*schemeConfig)
		fmt.Println("orm gen ok")
	}

	fmt.Println("build_gen main over")
}
