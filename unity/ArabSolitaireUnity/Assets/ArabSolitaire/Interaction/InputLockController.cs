using System;
using UnityEngine;

namespace ArabSolitaire.Interaction
{
    public sealed class InputLockController : MonoBehaviour
    {
        public bool IsLocked { get; private set; }
        public int ActivePointerId { get; private set; } = -1;

        public bool TryAcquirePointer(int pointerId)
        {
            if (IsLocked)
            {
                return false;
            }

            if (ActivePointerId >= 0 && ActivePointerId != pointerId)
            {
                return false;
            }

            ActivePointerId = pointerId;
            return true;
        }

        public void ReleasePointer(int pointerId)
        {
            if (ActivePointerId == pointerId)
            {
                ActivePointerId = -1;
            }
        }

        public void Lock() => IsLocked = true;

        public void Unlock()
        {
            IsLocked = false;
            ActivePointerId = -1;
        }
    }
}
