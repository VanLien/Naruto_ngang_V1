<?php  include("header.php");
?>

<style>
    .backgoud-img {
        position: relative;
        width: 100%;
        height: 100%;
        border-radius: 10px;
        padding: 20px;
    }

    .backgoud-img::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background-color: rgba(255, 255, 255, 0.7);
        z-index: 1;
    }

    .backgoud-img .caption {
        position: relative;
        z-index: 2;
    }
    table tr {
    color: darkblue;
}
</style>

<script>
    const pokemonImages = [
        "https://id.daichienpoke.com/images/hero/1.png",
        "https://id.daichienpoke.com/images/hero/2.png",
        "https://id.daichienpoke.com/images/hero/3.png",
        "https://id.daichienpoke.com/images/hero/4.png",
        "https://id.daichienpoke.com/images/hero/5.png",
        "https://id.daichienpoke.com/images/hero/6.png",
        "https://id.daichienpoke.com/images/hero/7.png",
        "https://id.daichienpoke.com/images/hero/8.png",
        "https://id.daichienpoke.com/images/hero/9.png",
        "https://id.daichienpoke.com/images/hero/10.png",
        "https://id.daichienpoke.com/images/hero/11.png",
        "https://id.daichienpoke.com/images/hero/12.png",
        "https://id.daichienpoke.com/images/hero/13.png",


    ];

    function setRandomBackground() {
        const elements = document.querySelectorAll('.backgoud-img');
        elements.forEach(element => {
            const randomImage = pokemonImages[Math.floor(Math.random() * pokemonImages.length)];
            element.style.backgroundImage = `url('${randomImage}')`;
            element.style.backgroundSize = 'cover';
            element.style.backgroundPosition = 'center';
            element.style.backgroundRepeat = 'no-repeat';
        });
    }

    // Chạy khi trang đã load xong
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', setRandomBackground);
    } else {
        setRandomBackground();
    }
</script>

<div class="row giftcodeparent">

<div class="card" id="history">
                        <div class="card-body">

                            <h5 class="card-title fw-semibold mb-4">Sự kiện tích nạp</h5>
                            <div class="card">
                                <div class="card-body">
                                    <div class="row intro">

                                        <div class="col-12">


                                            <div class="card box-gift">
                                                <div class="card-body ">

                                                <?php
                                                $startDate =  getConfig('startTichLuy');
                                                $endDate = getConfig('endTichLuy');
                                                if(strtotime($startDate) > time() || strtotime($endDate) < time()) {
                                                    echo '<div class="alert alert-danger" role="alert">Sự kiện đã kết thúc</div>';
                                                    exit;
                                                }

                                                $tongtien = getSumNapbyDate($username, $startDate, $endDate);
                                              ?>

                                                    <div class="alert alert-danger" role="alert">
                                                        <h5>Tổng nạp tích lũy : <?php echo number_format($tongtien) ?>
                                                            Xu</h5>
                                                        <p class="text-red"> Thời gian sự kiện : Từ
                                                            <?php echo humnanDate($startDate) ?> đến
                                                            <?php echo  humnanDate($endDate) ?></p>
                                                    </div>

                                                    <div class="alert alert-success">
                                                        <p>🎉 Sự kiện tích lũy nạp - Cơ hội nhận quà cực khủng! 🎉</p>
                                                        <p> Điểm tích lũy nạp sẽ được tích dần trong suốt sự kiện</p>
                                                        <p>Mỗi tài khoản chỉ nhận một lần tại các mốc tích lũy, nên hãy
                                                            chọn mốc cẩn thận nhé!</p>
                                                        <p>Khi sự kiện kết thúc, hệ thống sẽ reset điểm tích lũy hoàn
                                                            toàn.</p>
                                                        <p>Chú ý: Điểm tích lũy không tính khuyến mãi 20%</p>
                                                    </div>

                                                </div>
                                            </div>


          <div class="row">
                                                <?php 	
                    $data = $database->query("SELECT  * FROM `event_tichluy_pack` ORDER BY price ASC ")->fetchAll();
                           foreach($data as $row) {
                            
                           ?>
                                                <div class="col-md-12 card box-gift mb-4">
                                                    <div class="card-body text-center p-4 ">
                                                        <h4 class="fw-bold mb-3"><?php echo $tichluy['price']?></h4>
                                                        <div class="thumbnail backgoud-img ">
                                                            <div class="caption">
                                                                <h5 class="title-box mb-3">
                                                                    <span class="text-danger fw-bold"><?php echo $row['name']?></span>
                                                                </h5>
                                                                <div class="info-pack mb-4">
                                                                    <?php echo html_entity_decode($row['content'])?>
                                                                </div>
                                                                <?php 
                                           $idpack = $row['id'];
                                           $count = $database->count("log_event_tichluy", [
                                            "username" => $username,
                                            "pack_id" => $idpack
                                        ]);
                                           
                                           if ($count == 1) { ?>
                                                                <div class="alert alert-success" role="alert">
                                                                    <i class="bi bi-check-circle me-2"></i>Bạn đã nhận
                                                                </div>
                                                                <?php } elseif($tongtien > $row['price'] || $tongtien == $row['price'] ) { ?>
                                                                <div class="text-center">
                                                                    <button onclick="NhanGift(<?php echo $row['id']?>)" class="btn btn-primary px-4 py-2">
                                                                        <i class="bi bi-gift me-2"></i>Nhận quà
                                                                    </button>
                                                                </div>
                                                                <?php }else { ?>
                                                                <div class="alert alert-danger" role="alert">
                                                                    <i class="bi bi-exclamation-circle me-2"></i>Chưa đủ điều kiện
                                                                </div>
                                                                <?php } ?>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                                <?php } ?>

                                            </div>

                                        </div>



                                    </div>

                                </div>
                            </div>


                        </div>
                    </div>
                </div>

                <script>
                function NhanGift(id) {
                    <?php
                            $key = 'pokemon@123';
                            $time = time();
                            $sign = md5($time . $key . $username);
                            ?>
                    var sign = '<?php echo $sign ?>';
                    var time = '<?php echo $time ?>';
                    var idcode = id;
                    var username = '<?php echo  $username; ?>';
                    $.ajax({
                            url: 'buycode.html',
                            type: 'POST',
                            data: {
                                idcode: idcode,
                                username: username,
                                sign: sign,
                                time: time,
                            }, // it will serialize the form data
                            dataType: 'json'
                        })
                        .done(function(response) {

                            if (response.status == 0) {

                                var url = response['url'];
                                swal.fire({
                                    icon: 'success',
                                    title: 'Thành công',
                                    html: response['msg'],
                                }).then((result) => {
                                    if (result.value) {
                                        if (url != "") {
                                            window.location = url;
                                        }
                                    }
                                });
                            } else {
                                swal.fire({
                                    icon: 'error',
                                    title: 'Lỗi',
                                    text: response['msg'],
                                })

                            }

                        })
                        .fail(function() {
                            alert('Lỗi không xác định...');
                        });



                }
                </script>




</div>
<?php include("footer.php")?>





