#!/bin/bash
# update_llm.sh

update_docker() {
  # Retrieves the list of LLMs installed in the Docker container
llm_list=$(docker exec ollama ollama list | tail -n +2 | awk '{print $1}')

# Loop over each LLM to update it
for llm in $llm_list; do
  docker exec ollama ollama pull $llm
done
}

update_local() {
  # Retrieves the list of LLMs installed locally
llm_list=$(ollama list | tail -n +2 | awk '{print $1}')

# Loop over each LLM to update it
for llm in $llm_list; do
  ollama pull $llm
done
}

for getopts "dhl" opt; do
  case ${opt} in
    d)
      update_docker
      ;;
    h )
      echo "Usage: update_llm.sh [options]"
      echo "Options:"
      echo "-d Updates all LLMs installed in the Docker container"
      echo "-l Updates all LLMs installed locally"
      echo "Updates all LLMs installed in locally if no options are provided"
      exit 0
      ;;
    l)
      update_local
      ;;
    \? )
      echo "Invalid option: $OPTARG" 1>&2
      exit 1
      ;;
  esac
done

# If no options are provided, update the LLMs installed locally
if [ $# -eq 0 ]; then
  update_local
fi

echo "All LLMs updated successfully"

