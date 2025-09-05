// app/javascript/preview_image.js
function setPreviewIn(container, url) {
  const img = container.querySelector('.photo-preview');
  const dummy = container.querySelector('.photo-dummy');
  if (!img) return;

  img.src = url;
  img.removeAttribute('hidden');               // hidden属性そのものを外す
  img.style.display = 'block';                 // 念のため
  dummy && dummy.classList.add('is-preview');
  console.debug('[preview] set src:', url);
}

function handleFileInputChange(input) {
  const container = input.closest('.photo-field');
  if (!container) { console.debug('[preview] no .photo-field'); return; }

  const files = input.files;
  if (!files || files.length === 0) {
    const img = container.querySelector('.photo-preview');
    const dummy = container.querySelector('.photo-dummy');
    if (img) { img.setAttribute('hidden',''); img.removeAttribute('src'); img.style.display=''; }
    dummy && dummy.classList.remove('is-preview');
    console.debug('[preview] cleared');
    return;
  }

  const file = files[0];
  if (file.type && !file.type.startsWith('image/')) {
    alert('画像ファイルを選択してください。');
    input.value = '';
    return;
  }

  const url = URL.createObjectURL(file);
  setPreviewIn(container, url);
  const img = container.querySelector('.photo-preview');
  if (img) img.onload = () => URL.revokeObjectURL(url);
}

// ① 通常の <input type="file"> はイベント委譲で確実に拾う
document.addEventListener('change', (e) => {
  const target = e.target;
  if (!(target instanceof HTMLInputElement)) return;
  if (target.type !== 'file') return;
  if (!target.closest('.photo-field')) return;
  handleFileInputChange(target);
});

// ② Cloudinary(jQueryプラグイン)のイベントも拾う（使っている場合のみ）
document.addEventListener('turbo:load', () => {
  if (window.jQuery) {
    const $ = window.jQuery;
    $(document)
      .off('cloudinarydone.__preview')
      .on('cloudinarydone.__preview', '.cloudinary-fileupload', function (_e, data) {
        const url = data?.result?.secure_url;
        const container = this.closest('.photo-field');
        if (url && container) setPreviewIn(container, url);
      });
  }
});
