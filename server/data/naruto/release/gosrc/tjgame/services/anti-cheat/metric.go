package anti_cheat

import (
	"github.com/prometheus/client_golang/prometheus"
	"github.com/prometheus/client_golang/prometheus/promauto"
)

var (
	playWaiting = promauto.NewGaugeVec(prometheus.GaugeOpts{
		Name: "anticheat_plays_waiting_amount",
		Help: "The amount number of battle plays waiting in channel",
	}, []string{"service"})

	plays = promauto.NewCounterVec(prometheus.CounterOpts{
		Name: "anticheat_plays_process_count_total",
		Help: "The total number of processed plays",
	}, []string{"service"})

	elapsed = promauto.NewCounterVec(prometheus.CounterOpts{
		Name: "anticheat_runner_process_seconds_total",
		Help: "The total seconds of processed plays",
	}, []string{"service"})

	durationBucket = promauto.NewHistogramVec(prometheus.HistogramOpts{
		Name:    "anticheat_plays_durations_seconds",
		Help:    "plays latency distributions",
		Buckets: []float64{20, 40, 60, 80, 100, 150, 200, 250, 300, 400, 600, 800},
		//Buckets: prometheus.LinearBuckets(100, 100, 10),
	}, []string{"service"})
)
