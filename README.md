# S-UI Modern UI

Bản tùy biến giao diện của **S-UI** dành cho sing-box, tập trung vào giao diện hiện đại, dễ dùng trên điện thoại và desktop.

Upstream:
- Backend: https://github.com/alireza0/s-ui
- Frontend: https://github.com/alireza0/s-ui-frontend

## Thay đổi giao diện

- App bar dạng glass/blur, gọn hơn trên mobile.
- Sidebar hiện đại, item đang chọn dạng pill.
- Card, dialog, table, form và button bo góc đồng nhất.
- Nền light/dark mềm hơn, tăng độ tương phản nhưng không chói.
- Trang đăng nhập được thiết kế lại, responsive tốt hơn.
- Hiệu ứng hover/focus nhẹ, không làm nặng panel.
- Giữ nguyên logic, API và chức năng của S-UI.

## Build

```bash
chmod +x scripts/build-custom.sh
./scripts/build-custom.sh
```

Mặc định build từ upstream `v1.6.4`. Có thể chọn phiên bản khác:

```bash
SUI_UPSTREAM_VERSION=v1.6.4 ./scripts/build-custom.sh
```

File build được tạo trong thư mục `dist/`.

## Cấu trúc

```text
overrides/        # Các file giao diện ghi đè lên frontend upstream
scripts/          # Script build
.github/workflows # CI build/release
```

## License

Dự án này là bản tùy biến dựa trên S-UI và tiếp tục tuân theo **GNU GPL-3.0**. Bản quyền và thông tin của upstream được giữ nguyên theo yêu cầu của giấy phép.
