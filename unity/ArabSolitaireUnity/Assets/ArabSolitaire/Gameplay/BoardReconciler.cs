using ArabSolitaire.Bridge;
using Newtonsoft.Json.Linq;

namespace ArabSolitaire.Gameplay
{
    public static class BoardReconciler
    {
        public static bool NeedsReconcile(JObject authoritative, JObject presented)
        {
            if (authoritative == null || presented == null)
            {
                return true;
            }

            return authoritative.ToString() != presented.ToString();
        }

        public static JObject ExtractGameState(BridgeEnvelope snapshot) =>
            snapshot.payload?["gameState"] as JObject;
    }
}
