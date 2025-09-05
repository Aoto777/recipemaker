

if (document.URL.match(/new/)) {
  document.addEventListener('DOMContentLoaded', () => {
    const createImageHTML = (blob) => {
      const dummyElement = document.querySelector('.np-photo__dummy');

      // 既存プレビュー削除（再選択時に重複防止）
      const oldImage = dummyElement.querySelector('.new-img');
      if (oldImage) oldImage.remove();

      // 新しいimg要素を作成
      const blobImage = document.createElement('img');
      blobImage.setAttribute('class', 'new-img');
      blobImage.setAttribute('src', blob);

      dummyElement.appendChild(blobImage);
    };

    document.getElementById('tweet_image').addEventListener('change', (e) => {
      const file = e.target.files[0];
      if (!file) return;
      const blob = window.URL.createObjectURL(file);
      createImageHTML(blob);
    });
  });
}
