# Sample Project

Sample Ruby on Rails project for testing GitLab CI runner.

## Usage

The application is designed to containerized.

Commands are run through the [`./tasks`](./tasks) file:

- ```./tasks up``` - start the application
- ```./tasks down``` - stop the application
- ```./tasks build``` - build the application containers
- ```./tasks ex``` - run command in application container
- ```./tasks bash``` - enter shell in application container
- ```./tasks rspec``` - rspec test suite
- ```./tasks yarn``` - yarn
- ```./tasks rails``` - rails
- ```./tasks bundle``` - bundler
- ```./tasks rubocop``` - run ruby code linter
