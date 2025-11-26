local register = require("monaqa.snippet").register

register("script") { [=[
<script lang="ts">
  $0
</script>
]=] }

return register.snips
