namespace ArabSolitaire.Bridge
{
    public sealed class BridgeSessionGuard
    {
        private readonly BridgeMessageValidator _validator;

        public BridgeSessionGuard(int initialRevision = 0) =>
            _validator = new BridgeMessageValidator(initialRevision);

        public int AuthoritativeRevision => _validator.AuthoritativeRevision;

        public void RestoreRevision(int revision) =>
            _validator.AdvanceRevision(revision);

        public void ValidateIntent(BridgeEnvelope intent) =>
            _validator.ValidateInboundIntent(intent);

        public void AdvanceRevision(int newRevision) =>
            _validator.AdvanceRevision(newRevision);

        public bool IsReadyForInput { get; private set; } = true;

        public void LockInput() => IsReadyForInput = false;

        public void UnlockInput() => IsReadyForInput = true;
    }
}
