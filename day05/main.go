package main

import (
	"bufio"
	"log"
	"os"
	"sort"
	"strings"
)

type intRange struct {
	min int
	max int
}

func NewIntRange(pattern string, start, end int) *intRange {
	r := new(intRange)
	r.min = start
	r.max = end
	for _, p := range strings.Split(pattern, "") {
		if p == "F" || p == "L" {
			r.lowerHalf()
		} else if p == "B" || p == "R" {
			r.upperHalf()
		}
	}
	return r
}

func (r *intRange) upperHalf() {
	tmpRange := r.max - r.min
	newRange := tmpRange / 2
	r.min = r.max - newRange
}

func (r *intRange) lowerHalf() {
	tmpRange := r.max - r.min
	newRange := tmpRange / 2
	r.max = r.min + newRange
}

func (r *intRange) result() int {
	return r.max
}

func main() {
	f, _ := os.Open("input.txt")
	scanner := bufio.NewScanner(f)
	scanner.Split(bufio.ScanLines)

	result := make([]int, 0)

	for scanner.Scan() {
		p := scanner.Text()
		row := NewIntRange(p[:7], 0, 127)
		seat := NewIntRange(p[7:], 0, 7)

		result = append(result, row.result()*8+seat.result())
	}

	sort.Ints(result)

	log.Println("part 1", result[len(result)-1])

	for i, p := range result {
		if p+2 == result[i+1] { // let it crash if nothing is found at the end of the list
			log.Println("part 2", p+1)
			return
		}
	}

}
