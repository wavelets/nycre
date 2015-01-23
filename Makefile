BIN = node_modules/.bin

SALES = json/sales.json

SUMMARIES = json/summaries.json

ROLLING = json/rolling.json

HEADER = header.txt

JSONTOOL = $(shell $(BIN)/json $(2) --array < $(1))

YEARS = $(shell $(BIN)/json --keys --array < $(SALES))

BOROUGHS = manhattan bronx brooklyn queens statenisland

BOROUGHCSV = $(addsuffix .csv,$(BOROUGHS))

SALESFILES := $(addprefix sales/,$(addsuffix .csv,$(YEARS)))

SALESBOROUGHCSV := $(addprefix sales/,$(foreach y,$(YEARS),$(addprefix $(y)/,$(BOROUGHCSV))))
SALESBOROUGHXLS := $(addprefix sales/,$(foreach y,$(YEARS),$(addprefix $(y)/,$(addsuffix .xls,$(BOROUGHS)))))

SUMMARYFILES := $(addprefix summaries/,$(BOROUGHCSV))

ROLLINGCSVFILES := $(addprefix rolling/raw/borough/,$(BOROUGHCSV))

comma = ,
space :=
space +=


# Create rolling files 

# % should be YYYY-MM
rolling/%-city.csv: rolling/raw/city.csv | rolling/raw/borough
	$(eval y = $(shell date -jf '%Y-%m' '$*' +'%y'))
	$(eval m = $(shell date -jf '%Y-%m' '$*' +'%-m'))
	{ cat $(HEADER) ; grep $< -e '$(m)/[0-9][0-9]\?/$(y)' ; } > $@

.INTERMEDIATE: rolling/raw/city.csv
rolling/raw/city.csv: $(ROLLINGCSVFILES) | rolling/raw/borough
	{ cat $(HEADER) ; $(foreach csv,$(ROLLINGCSVFILES), tail -n+6 $(csv) ;) } > $@	

.INTERMEDIATE: rolling/raw/borough/%.csv
rolling/raw/borough/%.csv: rolling/raw/borough/%.xls | rolling/raw/borough
	$(BIN)/j -f $^ | grep -v -e '^,\+$$' -v -e '^$$' > $@

rolling/raw/borough/%.xls: | rolling/raw/borough
	curl "$(call JSONTOOL,$(ROLLING),.$*)" > $@

sales/%-city.csv: $(addprefix sales/%/,$(BOROUGHCSV)) | sales
	@echo $(addprefix sales/%/,$(BOROUGHCSV))
	{ cat $(HEADER) ; $(foreach file,$^,tail -n+6 $(file) ;) } > $@

.INTERMEDIATE: sales/%.csv
sales/%.csv: sales/%.xls | sales
	$(BIN)/j -f $^ | sed -Ee 's/ +("?),/\1,/g' | grep -v -e '^$$' -v -e '^,\+$$' > $@

sales/%.xls: | sales
	$(eval borough = $(shell echo $* | sed 's|[0-9]\{4\}/||'))
	$(eval year = $(shell echo $* | sed 's|/[a-z]*||'))

	curl "$(call JSONTOOL,$(SALES),.$(year).$(borough))" > $@

sales: ; mkdir -p $(addprefix sales/,$(YEARS))

summaries/%.csv: | summaries
	curl "$(call JSONTOOL,$(SUMMARIES),.$*)" > summaries/$*.xls
	$(eval sheets = $(subst $(space)Sales$(space),$(comma),$(shell $(BIN)/j -l summaries/$*.xls)))
	bin/sheetstack --groups $(sheets) --group-name year --rm-lines 4 summaries/$*.xls > $@

summaries/city: summaries ; mkdir -p summaries/city
summaries: ; mkdir -p summaries

rolling/raw/borough: ; mkdir -p rolling/raw/borough

.PHONY: clean
clean:
	rm -rf rolling summaries sales

.PHONY: install
install:
	npm install
	pip list | grep csvkit || pip install csvkit --user
