import { IndexCityListView } from 'index-listview/Index'
import promptAction from '@ohos.promptAction';
@Entry
@Component
struct Index {
  build() {
    Column() {
      IndexCityListView({
        clickCallback: (city: string) => {
          promptAction.showToast({ message: city })
        }
      })
    }
    .width('100%')
    .height('100%')
  }
}

