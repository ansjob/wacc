
SOURCES = $(wildcard *.pl) 

TESTS = $(wildcard *.tst)

all: while wanalyze

while: $(SOURCES)
	swipl --nodebug --toplevel=main --stand_alone=true -O -q -o while -c $(SOURCES)

wanalyze: $(SOURCES)
	swipl --nodebug --toplevel=wanalyze_main --stand_alone=true -O -q -o wanalyze -c $(SOURCES)

tester: $(SOURCES) $(TESTS)
	swipl --toplevel=test_main -q -O -o tester -c tester.pl 

test: tester
	@./tester

clean:
	@rm -f while tester wanalyze

variable_extractor.tex: variable_extractor.pl
	swipl -f docgen.pl \
		-g "latex_for_file('variable_extractor.pl','variable_extractor.tex',[stand_alone(false)]),halt" \
		-t "halt(1)"
