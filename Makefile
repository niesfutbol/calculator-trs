all: \
	lint \
	tests \
	coverage

define lint
	R -e "library(lintr)" \
	  -e "lint_dir('R', linters = with_defaults(line_length_linter(100)))" \
	  -e "lint_dir('tests/testthat', linters = with_defaults(line_length_linter(100)))"
endef

.PHONY: all check clean coverage linter tests

check:
	R -e "library(styler)" \
	  -e "resumen <- style_dir('tests')" \
	  -e "resumen <- rbind(resumen, style_dir('R'))" \
	  -e "any(resumen[[2]])" \
	  | grep FALSE

clean:
	rm *.tar.gz

coverage:
	R -e "cobertura <- covr::file_coverage(c('R/make_fit.R'), c('tests/testthat/test_make_fit.R'))" \
	  -e "covr::codecov(covertura=cobertura, token='7c66844a-93d6-4a2a-82ad-c85bf971e6d2')"

format:
	R -e "library(styler)" \
	  -e "style_dir('tests')" \
	  -e "style_dir('R')"

linter:
	$(lint)
	$(lint) | grep -e "\^" && exit 1 || exit 0

tests:
	R -e "testthat::test_dir('tests/testthat/', report = 'summary', stop_on_failure = TRUE)"
