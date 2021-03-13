[
  split("\n")[]                      # Transform csv input into array
| split("\",\"")                     # Split by `","`
| select(length==2)                  # Pick only arrays with exactly 2 elements; this removes header (because it's split by `", "` (notice the space after comma)) and empty array at the end
| {
    key: (.[0] | sub("^\""; "")),    # Get key and strip leading quote
    value: (.[1] | sub("\"$"; "")),  # Get value and strip trailing quote
  }
]
| from_entries                       # Transform into object
