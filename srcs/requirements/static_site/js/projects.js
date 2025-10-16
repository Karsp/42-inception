// Simple entry animation + modal lightbox + mouse tilt
document.addEventListener('DOMContentLoaded', () => {
  const cards = Array.from(document.querySelectorAll('.card'));
  cards.forEach((c, i) => setTimeout(()=> c.classList.add('visible'), i*120));

  // hover tilt effect
  cards.forEach(card => {
    card.addEventListener('mousemove', e => {
      const rect = card.getBoundingClientRect();
      const x = (e.clientX - rect.left) / rect.width - 0.5;
      const y = (e.clientY - rect.top) / rect.height - 0.5;
      card.style.transform = `translateY(0) rotateX(${(-y*6)}deg) rotateY(${(x*6)}deg) scale(1.02)`;
    });
    card.addEventListener('mouseleave', () => {
      card.style.transform = '';
    });

    card.addEventListener('click', () => openModal(card));
  });

  // modal logic
  const modal = document.getElementById('modal');
  const modalImg = document.getElementById('modalImg');
  const modalTitle = document.getElementById('modalTitle');
  const modalDesc = document.getElementById('modalDesc');
  const modalLink = document.getElementById('modalLink');
  const modalClose = document.getElementById('modalClose');

  function openModal(card){
    modalImg.src = card.querySelector('img').src;
    modalTitle.textContent = card.dataset.title;
    modalDesc.textContent = card.dataset.desc;
    modalLink.href = card.dataset.link;
    modal.setAttribute('aria-hidden', 'false');
  }
  function closeModal(){
    modal.setAttribute('aria-hidden', 'true');
    modalImg.src = '';
  }
  modalClose.addEventListener('click', closeModal);
  modal.addEventListener('click', e => { if(e.target === modal) closeModal(); });

  // keyboard close
  document.addEventListener('keydown', e => { if(e.key === 'Escape') closeModal(); });
});
