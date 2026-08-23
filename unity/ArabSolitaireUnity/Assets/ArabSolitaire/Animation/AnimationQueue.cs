using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace ArabSolitaire.Animation
{
    public sealed class AnimationQueue : MonoBehaviour
    {
        private readonly Queue<IEnumerator> _pending = new();
        private bool _running;

        public int QueuedCount => _pending.Count;
        public bool IsRunning => _running;

        public void Enqueue(IEnumerator step)
        {
            _pending.Enqueue(step);
            if (!_running)
            {
                StartCoroutine(RunQueue());
            }
        }

        public void Clear()
        {
            _pending.Clear();
            StopAllCoroutines();
            _running = false;
        }

        private IEnumerator RunQueue()
        {
            _running = true;
            while (_pending.Count > 0)
            {
                yield return _pending.Dequeue();
            }

            _running = false;
        }
    }
}
