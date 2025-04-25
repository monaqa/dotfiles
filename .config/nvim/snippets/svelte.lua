local snips = {}

local register = require("monaqa.snippet").new_registerer(snips)

register("script")([=[
<script lang="ts">
  $0
</script>
]=])

return snips
