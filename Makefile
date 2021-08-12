all: \
	lint \
	tests \
	coverage

define lint
	R -e "library(lintr)" \
	  -e "lint_dir('R', linters = with_defaults(line_length_linter(100)))" \
	  -e "lint_dir('tests/testthat', linters = with_defaults(line_length_linter(100)))"
endef

.PHONY: all check clean coverage linter results tests

results/xTable_262_2021.csv:
	mkdir --parents $(@D)
	Rscript -e "source('src/calculate_xPoint.R')"

results: src/calculate_xGoal.R
	mkdir --parents $(@D)
	Rscript -e "source('src/calculate_xGoal.R')"

check:
	R -e "library(styler)" \
	  -e "resumen <- style_dir('tests')" \
	  -e "resumen <- rbind(resumen, style_dir('R'))" \
	  -e "any(resumen[[2]])" \
	  | grep FALSE

clean:
	rm *.tar.gz

coverage:
	R -e "cobertura <- covr::file_coverage(c('R/calculate_trs.R'), c('tests/testthat/test_calculate_trs.R'))" \
	  -e "covr::codecov(covertura=cobertura, token='1618c982-0462-40d3-b33c-7b7f1c654e96')"

format:
	R -e "library(styler)" \
	  -e "style_dir('tests')" \
	  -e "style_dir('R')"

linter:
	$(lint)
	$(lint) | grep -e "\^" && exit 1 || exit 0

tests:
	R -e "testthat::test_dir('tests/testthat/', report = 'summary', stop_on_failure = TRUE)"
