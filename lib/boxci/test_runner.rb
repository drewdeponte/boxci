module Boxci
  class TestRunner
    def initialize(language)
      @language = language
    end
    
    def generate_script
      snippets = []
      snippets << %q{#!/bin/bash --login}
      snippets << %q{BOXCI_TEST_RESULT=0}
      snippets << <<SNIPPET
PROJECT_DIR="/vagrant/project"
mkdir $PROJECT_DIR
tar -xf /vagrant/project.tar -C $PROJECT_DIR
cd $PROJECT_DIR 
SNIPPET

      snippets << generate_short_circuiting_hook_script('before_install')
      snippets << generate_short_circuiting_hook_script('install')

      snippets << short_circuit_on_step_failure('before_permutation_switch', @language.before_permutation_switch)

      if Boxci.project_config.permutations
        Boxci.project_config.permutations.each do |current_permutation|
          snippets << current_permutation.switch_to_script

          snippets << short_circuit_on_step_failure('after_permutation_switch', @language.after_permutation_switch)

          snippets << generate_short_circuiting_hook_script('before_script')
          snippets << generate_script_hook_script
          snippets << %q{export BOXCI_TEST_RESULT=$BOXCI_TEST_RESULT}
          snippets << generate_after_success_and_failure_hook_script
          snippets << generate_continue_and_ignore_hook_script('after_script')
        end
      else
        snippets << short_circuit_on_step_failure('after_permutation_switch', @language.after_permutation_switch)

        snippets << generate_short_circuiting_hook_script('before_script')
        snippets << generate_script_hook_script
        snippets << %q{export BOXCI_TEST_RESULT=$BOXCI_TEST_RESULT}
        snippets << generate_after_success_and_failure_hook_script
        snippets << generate_continue_and_ignore_hook_script('after_script')
      end
      snippets << %{exit $BOXCI_TEST_RESULT}
      return snippets.join("\n")
    end

    private

    def generate_after_success_and_failure_hook_script
      <<SNIPPET
if [ $BOXCI_TEST_RESULT -eq 0 ]; then
:
#{generate_continue_and_ignore_hook_script('after_success')}
else
:
#{generate_continue_and_ignore_hook_script('after_failure')}
fi
SNIPPET
    end

    def generate_short_circuiting_hook_script(hook_name)
      if !Boxci.project_config.send(hook_name.to_sym).empty?
        snippets = []
        Boxci.project_config.send(hook_name.to_sym).each do |step|
          snippets << short_circuit_on_step_failure(hook_name, step)
        end
        return snippets.join("\n")
      else
        return %Q(# Placeholder where '#{hook_name}' would go if it was set.)
      end
    end

    def generate_continue_and_ignore_hook_script(hook_name)
      if !Boxci.project_config.send(hook_name.to_sym).empty?
        snippets = []
        Boxci.project_config.send(hook_name.to_sym).each do |step|
          snippets << continue_and_ignore_on_step_failure(hook_name, step)
        end
        return snippets.join("\n")
      else
        return %Q(# Placeholder where '#{hook_name}' would go if it was set.)
      end
    end

    def generate_script_hook_script
      if !Boxci.project_config.script.empty?
        snippets = []
        Boxci.project_config.script.each do |step|
          snippets << continue_on_step_failure('script', step)
        end
        return snippets.join("\n")
      else
        return continue_on_step_failure('script', @language.default_script)
      end
    end

    def short_circuit_on_step_failure(hook_name, step)
      if step && !step.empty?
        <<SNIPPET
# Beginning of '#{hook_name}' step '#{step}'
echo "Running '#{hook_name}' step '#{step}'"
step_exit_code=0
#{step}
step_exit_code=$?
if [ $step_exit_code -ne 0 ]; then
  echo "Err: #{hook_name} step '#{step}' exited with non-zero exit code ($step_exit_code)"
  exit 1
fi
# End of '#{hook_name}' step '#{step}'
SNIPPET
      else
        %Q(# Placeholder where '#{hook_name}' would go if it was set.)
      end
    end

    def continue_on_step_failure(hook_name, step)
      if step && !step.empty?
        <<SNIPPET
# Beginning of '#{hook_name}' step '#{step}'
echo "Running '#{hook_name}' step '#{step}'"
step_exit_code=0
#{step}
step_exit_code=$?
if [ $step_exit_code -ne 0 ]; then
  echo "Warning: #{hook_name} step '#{step}' exited with non-zero exit code ($step_exit_code)."
  BOXCI_TEST_RESULT=1
fi
# End of '#{hook_name}' step '#{step}'
SNIPPET
      else
        %Q(# Placeholder where '#{hook_name}' would go if it was set.)
      end
    end

    def continue_and_ignore_on_step_failure(hook_name, step)
      if step && !step.empty?
        <<SNIPPET
# Beginning of '#{hook_name}' step '#{step}'
echo "Running '#{hook_name}' step '#{step}'"
step_exit_code=0
#{step}
step_exit_code=$?
if [ $step_exit_code -ne 0 ]; then
  echo "Warning: #{hook_name} step '#{step}' exited with non-zero exit code ($step_exit_code)."
fi
# End of '#{hook_name}' step '#{step}'
SNIPPET
      else
        %Q(# Placeholder where '#{hook_name}' would go if it was set.)
      end
    end
  end
end
